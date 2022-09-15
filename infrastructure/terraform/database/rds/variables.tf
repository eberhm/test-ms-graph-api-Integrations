variable "name" {
  description = "the name of the application"
  type        = string
}

variable "db_name" {
  description = "the name of the database"
  type        = string
}

variable "environment" {
  description = "the name of the environment, e.g. \"production\""
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "vpc_private_subnet_ids" {
  description = "VPC private subnet"
}

variable "vpn_ip_cidr" {
  description = "CIDRs of Xing's VPN"
}

variable "allowed_ingress_sg_ids" {
  description = "Allowed  ingress security groups ids"
  type        = set(string)
}

variable "backup_retention_period" {
  description = "The backup retention period in days"
  type        = number
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled, default true"
  type        = bool
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
}