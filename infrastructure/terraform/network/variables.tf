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

variable "availability_zones" {
  description = "list of availability zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  type        = list(any)
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPCs"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  type        = list(any)
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  type        = list(any)
}
