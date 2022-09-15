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

variable "region" {
  description = "the AWS region in which resources are created"
  default     = "eu-central-1"
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

variable "vpn_ip_cidr" {
  description = "CIDRs of Xing's VPN"
}


variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "main"
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

variable "allowed_ingress_sg_ids" {
  description = "Allowed  ingress security groups ids"
  type        = set(string)
}
