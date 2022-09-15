output "state_machine_arn" {
  value = aws_sfn_state_machine.db_migration_state_machine.arn
}