resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"
  tags = {
    Name = "${var.name}-cluster-${var.environment}"

  }
}

output "id" {
  value = aws_ecs_cluster.main.id
}

output "name" {
  value = aws_ecs_cluster.main.name
}
output "arn" {
  value = aws_ecs_cluster.main.arn
}
