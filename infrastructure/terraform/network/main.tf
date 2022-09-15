terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }

  # Backend is defined in the Terragrunt configuration
  # See ../enviornments/preview/terragrunt.hcl
  backend "s3" {
  }

  required_version = ">= 1.1.9"
}


provider "aws" {
  region = var.region

  # Provide tags for all resources maintained by Terraform
  # See https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html#tag-categories
  default_tags {
    tags = {
      Application  = var.name
      Environment  = var.environment
      Owner        = var.owner
      Contact      = var.contact
      BusinessUnit = var.business_unit
      CostCenter   = var.cost_center
    }
  }
}

module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}
