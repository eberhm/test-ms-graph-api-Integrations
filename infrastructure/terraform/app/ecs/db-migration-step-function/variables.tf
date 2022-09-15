variable "name" {
  description = "The name of your application"
}

variable "region" {
  type = string
}

variable "cluster_arn" {
  type        = string
  description = "ECS cluster arn"
}

variable "task_definition_arn" {
  type        = string
  description = "Task definition arn"
}

variable "vpc_private_subnet_ids" {
  description = "vpc private subnets ids"
  type        = set(string)
}

variable "task_security_group_id" {
  description = "task security group id"
  type        = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}
