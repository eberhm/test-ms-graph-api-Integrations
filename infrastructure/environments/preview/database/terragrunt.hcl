terraform {
  source = "../../..//terraform/database"
}

locals {
  environment = "preview"
  account = get_aws_account_id()
  common = jsondecode(file(find_in_parent_folders("config.json")))
  assert_correct_account = get_aws_account_id() != jsondecode(file(find_in_parent_folders("config.json"))).accounts.preview  ? file("ERROR: wrong account") : null
}

remote_state {
  backend = "s3"
  config = {
    bucket = "nw-bucket-terraform-state-${local.account}-${local.environment}-${local.common.aws.region}" # bucket names need to be unique
    key = "${local.common.application_name}/${local.environment}/database/terraform.tfstate"
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

dependency "app" {
  config_path = "../app"
  
  mock_outputs = {
    ecs_tasks_sg_id = "1"
  }
  mock_outputs_allowed_terraform_commands = ["validate","plan","init"]
}

inputs = {
  account = local.common.accounts.preview

  region                 = local.common.aws.region
  name                   = local.common.application_name
  environment            = local.environment
  owner                  = local.common.owner
  contact                = local.common.contact
  business_unit          = local.common.business_unit
  cost_center            = local.common.cost_center
 
  db_name                = local.common.aws.db_name

  vpc_id                 = dependency.network.outputs.vpc_id
  vpc_public_subnet_ids  = dependency.network.outputs.vpc_public_subnets_ids
  vpc_private_subnet_ids = dependency.network.outputs.vpc_private_subnets_ids

  vpn_ip_cidr = local.common.xing_vpn_cidr

  allowed_ingress_sg_ids = [dependency.app.outputs.ecs_tasks_sg_id]
  
  rds = {
    backup_retention_period = 5
    skip_final_snapshot = false 
    deletion_protection = true
    instance_class = "db.t3.micro"
  }
}



