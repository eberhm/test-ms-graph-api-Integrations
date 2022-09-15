data "aws_secretsmanager_secret" "recommendations_host_secret" {
  name = "${var.environment}/${var.name}-service/ds-host-secret"
}

data "aws_secretsmanager_secret_version" "recommendations_host_secret" {
  secret_id = data.aws_secretsmanager_secret.recommendations_host_secret.id
}

data "aws_secretsmanager_secret" "db_connection_string_secret" {
  name = "${var.environment}/${var.name}-service/db-connection-string-secret"
}