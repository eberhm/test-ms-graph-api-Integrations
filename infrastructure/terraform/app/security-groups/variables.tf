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

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Port of the container"
}

variable "vpn_ip_cidr" {
  description = "CIDRs of Xing's VPN"
}