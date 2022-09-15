variable "name" {
  description = "The name of your application"
}

variable "environment" {
  type = string
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(any)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(any)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(any)
}