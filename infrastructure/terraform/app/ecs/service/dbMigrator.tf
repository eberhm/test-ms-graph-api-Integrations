resource "aws_cloudwatch_log_group" "db_migrator" {
  name = "${var.cloudwatch_group}-db-migrator"

  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}

data "template_file" "task_db_migrator_template" {
  template = file("${path.module}/templates/task.json.tpl")

  vars = {
    recommendations_host  = data.aws_secretsmanager_secret_version.ds_host_secret.arn
    db_connection_string  = data.aws_secretsmanager_secret.db_connection_string_secret.arn
    name                  = "${var.name}-container-${var.environment}"
    container_image_url   = "${var.registry_url}-dbmigrator:latest"
    container_cpu         = var.container_cpu
    container_memory      = var.container_memory
    container_environment = jsonencode(var.container_environment)
    container_port        = var.container_port
    region                = var.region
    cloudwatch_group      = var.cloudwatch_group
  }
}

resource "aws_ecs_task_definition" "db_migrator" {
  family                   = "${var.name}-task-${var.environment}-db-migrator"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.shared_resources.task_execution_role.arn
  task_role_arn            = var.shared_resources.ecs_tasks_role.arn
  container_definitions    = data.template_file.task_db_migrator_template.rendered
  depends_on               = [var.cluster_id]
  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}


output "db_migratior_task_definition_arn" {
  value = aws_ecs_task_definition.db_migrator.arn
}
