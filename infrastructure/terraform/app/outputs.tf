
output "service_vpc_endpoint_name" {
  value = module.vpc_endpoint.service_vpc_endpoint.service_name
}

output "db_migration_state_machine_arn" {
  value = module.db_migration_step_function.state_machine_arn
}

output "ecs_tasks_sg_id" {
  value = module.security_groups.ecs_tasks
}