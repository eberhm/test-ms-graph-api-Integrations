resource "aws_cloudwatch_log_group" "main" {
  name = var.cloudwatch_group

  tags = {
    Name = "${var.name}-task-${var.environment}"

  }
}



data "template_file" "task_template" {
  template = file("${path.module}/templates/task.json.tpl")

  vars = {
    recommendations_host  = data.aws_secretsmanager_secret_version.ds_host_secret.arn
    db_connection_string  = data.aws_secretsmanager_secret.db_connection_string_secret.arn
    name                  = "${var.name}-container-${var.environment}"
    container_image_url   = "${var.registry_url}:latest"
    container_cpu         = var.container_cpu
    container_memory      = var.container_memory
    container_environment = jsonencode(var.container_environment)
    container_port        = var.container_port
    region                = var.region
    cloudwatch_group      = var.cloudwatch_group
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.shared_resources.task_execution_role.arn
  task_role_arn            = var.shared_resources.ecs_tasks_role.arn
  container_definitions    = data.template_file.task_template.rendered
  depends_on               = [var.cluster_id]
  tags = {
    Name = "${var.name}-task-${var.environment}"
  }
}

resource "aws_ecs_service" "main" {
  name                   = "${var.name}-service-${var.environment}"
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.main.arn
  desired_count          = var.service_desired_count
  launch_type            = "FARGATE"
  scheduling_strategy    = "REPLICA"
  enable_execute_command = true
  depends_on             = [var.cluster_id]
  network_configuration {
    security_groups  = [var.task_security_group_id]
    subnets          = var.vpc_private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }

  load_balancer {
    target_group_arn = var.aws_nlb_target_group_arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
#Autoscaling
#Requires cluster and service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

