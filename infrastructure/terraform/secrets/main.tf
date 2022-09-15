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

module "rds" {
  source      = "./rds"
  name        = var.name
  environment = var.environment
}
module "ecs" {
  source      = "./ecs"
  name        = var.name
  environment = var.environment
}

output "secrets_arn" {
  value = concat(module.ecs.secrets_arn, module.rds.secrets_arn)
}
