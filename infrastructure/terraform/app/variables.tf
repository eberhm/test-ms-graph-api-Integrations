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

variable "owner" {
  type = string
}

variable "contact" {
  type = string
}

variable "business_unit" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "cloudwatch_group" {
  description = "the AWS cloudwatch logs group"
}

variable "region" {
  description = "the AWS region in which resources are created"
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "list of availability zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  type        = list(any)
}

variable "vpc_prefix" {
  description = "the prefix/name of the VPC which is created in another module"
  type        = string
}

variable "vpc_id" {
  description = "the id of the vpc which is created in another module"
  type        = string
}

variable "vpc_public_subnet_ids" {
  description = "vpc public subnets ids"
  type        = set(string)
}

variable "vpc_private_subnet_ids" {
  description = "vpc private subnets ids"
  type        = set(string)
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "main"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
  default     = 2
}

variable "container_port" {
  description = "Port of the container"
  default     = 80
}

variable "container_cpu" {
  description = "CPU used by the task"
  default     = 256
}

variable "container_memory" {
  description = "Memory in MB used by the task"
  default     = 512
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/_system/alive"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list(any)
}

variable "api_gateway_account_id" {
  description = "account id of the central api gateway account"
  type        = string
}

variable "vpn_ip_cidr" {
  description = "CIDRs of Xing's VPN"
}

variable "rds" {
  description = "RDS parameters"
  type = object({
    backup_retention_period = number
    skip_final_snapshot     = bool
    deletion_protection     = bool
    instance_class          = string
  })
}
