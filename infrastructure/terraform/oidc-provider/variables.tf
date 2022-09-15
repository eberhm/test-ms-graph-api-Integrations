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

variable "github_repository" {
  description = "the Github repo where the oidc connection is needed"
}


variable "policies_arn" {
  description = "List of policies to be attached to the role used to deploy to AWS"
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}