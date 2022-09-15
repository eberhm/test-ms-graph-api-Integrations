resource "aws_secretsmanager_secret" "recommendations_host_secret" {
  name = "${var.environment}/${var.name}-service/ds-host-secret"
}

output "secrets_arn" {
  value = ["${aws_secretsmanager_secret.recommendations_host_secret.id}"]
} 