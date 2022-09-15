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



