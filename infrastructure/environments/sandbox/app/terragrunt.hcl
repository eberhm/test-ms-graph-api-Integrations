terraform {
  source = "../../..//terraform/app"
}

locals {
  environment = "sandbox"
  account = get_aws_account_id()
  common = jsondecode(file(find_in_parent_folders("config.json")))
  assert_correct_account = get_aws_account_id() != jsondecode(file(find_in_parent_folders("config.json"))).accounts.sandbox  ? file("ERROR: wrong account") : null
}


remote_state {
  backend = "s3"
  config = {
    bucket = "nw-bucket-terraform-state-${local.account}-${local.environment}-${local.common.aws.region}" # bucket names need to be unique
    key = "${local.common.application_name}/${local.environment}/app/terraform.tfstate" # <APPLICATION>/<ENVIRONMENT>/terraform.tfstate
    region = local.common.aws.region
    dynamodb_table = "nw-ddbtable-terraform-state"

    encrypt = true
    acl = "private"
  }
}

prevent_destroy = false

dependency "network" {
  config_path = "../network"
  
 mock_outputs = {
    vpc_id = "temporary-dummy-id"
    vpc_public_subnets_ids =  toset(["1", "2"])
    vpc_private_subnets_ids =  toset(["13", "23"]) 
  }
  mock_outputs_allowed_terraform_commands = ["validate","plan","init"]
}

inputs = {
  region                = local.common.aws.region
  api_gateway_account_id = "235517652197"
  name                  = local.common.application_name
  environment           = local.environment
  owner                 = local.common.owner
  contact               = local.common.contact
  business_unit         = local.common.business_unit
  cost_center           = local.common.cost_center
  availability_zones    = local.common.aws.availability_zones
  vpc_prefix            = local.common.aws.vpc_prefix
  db_name               = local.common.aws.db_name
  container_image_url   = "${local.account}.dkr.ecr.eu-central-1.amazonaws.com/${local.common.application_name}-${local.environment}"
  cloudwatch_group      = "/ecs/${local.common.application_name}-task-${local.environment}"

  vpc_id         = dependency.network.outputs.vpc_id
  vpc_public_subnet_ids     = dependency.network.outputs.vpc_public_subnets_ids
  vpc_private_subnet_ids     = dependency.network.outputs.vpc_private_subnets_ids

  rds = {
    backup_retention_period = 2
    skip_final_snapshot = true
    deletion_protection = false
    instance_class = "db.t3.micro"
  }

  vpn_ip_cidr = local.common.xing_vpn_cidr

  container_environment = [
    {
      "name": "LOG_LEVEL",
      "value": "DEBUG"
    },
    {
      "name": "PORT",
      "value": "80"
    },
        {
      "name": "NODE_ENV",
      "value": "sandbox"
    },
  ]
}



