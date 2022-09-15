variable "name" {
  description = "the name of the application"
  type        = string
}

variable "environment" {
  description = "the name of the environment, e.g. \"production\""
}


variable "alb_security_group_id" {
  description = "alb security group id"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "vpc_public_subnet_ids" {
  description = "VPC public subnet_ids"
}

variable "health_check_path" {
  description = "Route to get the healh status of the service"
}