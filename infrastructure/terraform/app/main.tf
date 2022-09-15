

#Security groups
module "security_groups" {
  source         = "./security-groups"
  name           = var.name
  vpc_id         = var.vpc_id
  environment    = var.environment
  container_port = var.container_port
  vpn_ip_cidr    = var.vpn_ip_cidr
}

## BELONGS TO THE APPLICATION
module "ecr" {
  source      = "./ecr"
  name        = var.name
  environment = var.environment
}

module "ecs_cluster" {
  source      = "./ecs/cluster"
  name        = var.name
  environment = var.environment
}

module "alb" {
  source                = "./alb"
  name                  = var.name
  environment           = var.environment
  health_check_path     = var.health_check_path
  vpc_id                = var.vpc_id
  vpc_public_subnet_ids = var.vpc_public_subnet_ids
  alb_security_group_id = module.security_groups.alb
}

module "ecs_shared_resources" {
  source      = "./ecs/sharedResources"
  name        = var.name
  environment = var.environment
  region      = var.region
}

module "ecs" {
  source                   = "./ecs/service"
  name                     = var.name
  environment              = var.environment
  region                   = var.region
  vpc_id                   = var.vpc_id
  vpc_private_subnet_ids   = var.vpc_private_subnet_ids
  aws_alb_target_group_arn = module.alb.aws_alb_target_group_arn
  aws_nlb_target_group_arn = module.vpc_endpoint.aws_nlb_target_group_arn
  cluster_name             = module.ecs_cluster.name
  cluster_id               = module.ecs_cluster.id
  container_port           = var.container_port
  container_cpu            = var.container_cpu
  container_memory         = var.container_memory
  service_desired_count    = var.service_desired_count
  registry_url             = module.ecr.aws_ecr_application_repository_url
  container_environment    = var.container_environment
  cloudwatch_group         = var.cloudwatch_group
  shared_resources         = module.ecs_shared_resources
  task_security_group_id   = module.security_groups.ecs_tasks
}

module "vpc_endpoint" {
  source                 = "git@github.com:onlyfyio/terraform-modules//modules/terraform-vpc-endpoint?ref=v1.2.1"
  name                   = var.name
  environment            = var.environment
  vpc_id                 = var.vpc_id
  vpc_private_subnet_ids = var.vpc_private_subnet_ids
  lb_security_group_id   = module.security_groups.alb
  other_account_id       = var.api_gateway_account_id
  health_check_path      = var.health_check_path
  acceptance_required    = false
}

module "db_migration_step_function" {
  source                 = "./ecs/db-migration-step-function"
  name                   = var.name
  region                 = var.region
  cluster_arn            = module.ecs_cluster.arn
  task_definition_arn    = module.ecs.db_migratior_task_definition_arn
  vpc_private_subnet_ids = var.vpc_private_subnet_ids
  task_security_group_id = module.security_groups.ecs_tasks
  execution_role_arn     = module.ecs_shared_resources.task_execution_role.arn
  task_role_arn          = module.ecs_shared_resources.ecs_tasks_role.arn
}

module "sqs_sample_queue" {
  source      = "./sqs"
  name        = var.name
  environment = var.environment
}
