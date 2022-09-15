resource "random_password" "db_master_password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.environment}/${var.name}-service/db-password-secret"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_master_password.result
}

resource "aws_secretsmanager_secret" "db_connection_string" {
  name = "${var.environment}/${var.name}-service/db-connection-string-secret"
}

output "secrets_arn" {
  value = ["${aws_secretsmanager_secret.db_password.id}", "${aws_secretsmanager_secret.db_connection_string.id}"]
} 