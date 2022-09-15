resource "aws_db_subnet_group" "ecs_db" {
  name       = "${var.name}-${var.environment}-database_subnet"
  subnet_ids = var.vpc_private_subnet_ids
}

data "aws_secretsmanager_secret" "db_password" {
  name = "${var.environment}/${var.name}-service/db-password-secret"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

resource "aws_security_group" "ecs_to_rds" {
  name        = "${var.name}-sg-ecs-rds-access"
  description = "allow inbound access from the ecs tasks only"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = "3306"
    to_port         = "3306"
    security_groups = var.allowed_ingress_sg_ids
  }

  ingress {
    protocol    = "tcp"
    from_port   = "3306"
    to_port     = "3306"
    cidr_blocks = [var.vpn_ip_cidr]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.name}database"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = var.instance_class
  db_name                = "${var.db_name}db"
  username               = "admin"
  password               = data.aws_secretsmanager_secret_version.db_password.secret_string
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.ecs_db.name
  vpc_security_group_ids = ["${aws_security_group.ecs_to_rds.id}"]

  # Backups are required in order to create a replica
  final_snapshot_identifier = "${var.name}-db-snapshot-id"
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = var.skip_final_snapshot
  deletion_protection       = var.deletion_protection
  storage_encrypted         = true

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  multi_az = true

}

resource "aws_db_instance" "db-replica" {
  count      = 1
  identifier = "${var.name}-db-replica"

  replicate_source_db = aws_db_instance.rds.id

  instance_class = var.instance_class

  port = 3306

  multi_az               = true
  vpc_security_group_ids = ["${aws_security_group.ecs_to_rds.id}"]

  maintenance_window              = "Tue:00:00-Tue:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  final_snapshot_identifier = "${var.name}-db-replica-snapshot-id"
  storage_encrypted         = true
}

data "aws_secretsmanager_secret" "db_connection_string_secret" {
  name = "${var.environment}/${var.name}-service/db-connection-string-secret"
}

resource "aws_secretsmanager_secret_version" "db_connection_string_secret" {
  secret_id     = data.aws_secretsmanager_secret.db_connection_string_secret.id
  secret_string = "${aws_db_instance.rds.engine}://${aws_db_instance.rds.username}:${data.aws_secretsmanager_secret_version.db_password.secret_string}@${aws_db_instance.rds.endpoint}/${aws_db_instance.rds.name}?sslcert=eu-central-1-bundle.pem"
}

