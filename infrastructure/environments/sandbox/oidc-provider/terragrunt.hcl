terraform {
  source = "../../../..//infrastructure/terraform/oidc-provider"
}

locals {
  environment = "sandbox"
  account = get_aws_account_id()
  common = jsondecode(file(find_in_parent_folders("config.json")))
  assert_correct_account = get_aws_account_id() != jsondecode(file(find_in_parent_folders("config.json"))).accounts.sandbox? file("ERROR: wrong account") : null
}

remote_state {
  backend = "s3"
  config = {
    bucket = "nw-bucket-terraform-state-${local.account}-${local.environment}-${local.common.aws.region}" 
    key = "${local.common.application_name}/${local.environment}/oidc-provider/terraform.tfstate" 
    region = local.common.aws.region
    dynamodb_table = "nw-ddbtable-terraform-state"

    encrypt = true
    acl = "private"
  }
}

prevent_destroy = false

inputs = {
  region                = local.common.aws.region
  name                  = local.common.application_name
  environment           = local.environment
  owner                 = local.common.owner
  contact               = local.common.contact
  business_unit         = local.common.business_unit
  cost_center           = local.common.cost_center
}
