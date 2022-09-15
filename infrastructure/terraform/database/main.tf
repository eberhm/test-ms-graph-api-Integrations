module "rds" {
  source                 = "./rds"
  name                   = var.name
  db_name                = var.db_name
  environment            = var.environment
  vpc_id                 = var.vpc_id
  vpc_private_subnet_ids = var.vpc_private_subnet_ids
  vpn_ip_cidr            = var.vpn_ip_cidr

  allowed_ingress_sg_ids  = var.allowed_ingress_sg_ids
  backup_retention_period = var.rds.backup_retention_period
  skip_final_snapshot     = var.rds.skip_final_snapshot
  deletion_protection     = var.rds.deletion_protection
  instance_class          = var.rds.instance_class
}
