variable "name" {
  description = "The name of your application"
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["production", "sandbox", "preview"], var.environment)
    error_message = "Provide valid environment (production, sandbox, preview)."
  }
}

variable "cloudwatch_group" {
  description = "the AWS cloudwatch logs group"
}

variable "region" {
  description = "the AWS region in which resources are created"
}

# variable "subnets" {
#   description = "List of subnet IDs"
# }

variable "cluster_name" {
  description = "The ECS cluster name that will own the service"
}

variable "cluster_id" {
  description = "The ECS cluster id that will own the service"
}

# variable "ecs_service_security_groups" {
#   description = "Comma separated list of security groups"
# }

variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "CPU used by the task"
}

variable "container_memory" {
  description = "Memory in MB used by the task"
}

variable "registry_url" {
  description = "Docker image to be launched"
  type        = string
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}
variable "aws_nlb_target_group_arn" {
  description = "ARN of the network lb target group"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
}

variable "shared_resources" {
  description = "Module containing the required and shared resources"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "vpc_private_subnet_ids" {
  description = "VPC private subnet ids"
}


variable "task_security_group_id" {
  description = "task security group id"
  type        = string
}
