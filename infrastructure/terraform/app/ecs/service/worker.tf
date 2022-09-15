resource "aws_cloudwatch_log_group" "worker" {
  name = "${var.cloudwatch_group}-worker"

  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}

data "template_file" "task_template_worker" {
  template = file("${path.module}/templates/task.json.tpl")

  vars = {
    recommendations_host = data.aws_secretsmanager_secret_version.ds_host_secret.arn
    db_connection_string = data.aws_secretsmanager_secret.db_connection_string_secret.arn
    name                 = "${var.name}-container-${var.environment}-worker"
    container_image_url  = "${var.registry_url}:latest"
    container_cpu        = var.container_cpu
    container_memory     = var.container_memory
    container_environment = jsonencode(concat([{
      "name" : "APPLICATION_MODE",
      "value" : "WORKER"
    }], var.container_environment))
    container_port   = var.container_port
    region           = var.region
    cloudwatch_group = "${var.cloudwatch_group}-worker"
  }
}

resource "aws_ecs_task_definition" "worker" {
  family                   = "${var.name}-task-${var.environment}-worker"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.shared_resources.task_execution_role.arn
  task_role_arn            = var.shared_resources.ecs_tasks_role.arn
  container_definitions    = data.template_file.task_template_worker.rendered
  depends_on               = [var.cluster_id]
  tags = {
    Name = "${var.name}-task-${var.environment}-worker"
  }
}

resource "aws_ecs_service" "worker" {
  name                   = "${var.name}-service-${var.environment}-worker"
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.worker.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  scheduling_strategy    = "REPLICA"
  enable_execute_command = true
  depends_on             = [var.cluster_id]

  network_configuration {
    security_groups  = [var.task_security_group_id]
    subnets          = var.vpc_private_subnet_ids
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}