locals {
  team        = "Unicode Snowpeople"
  team_id     = lower(replace(local.team, " ", "-"))
  environment = "Staging"
}

module "network" {
  source      = "./network"
  team        = local.team
  environment = local.environment
}

resource "aws_db_subnet_group" "databases" {
  name        = "primary-database-subnet-group"
  subnet_ids  = module.network.subnet_ids

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_db_instance" "bigmaven" {
  identifier              = "${local.team_id}-${lower(local.environment)}-db"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.small"
  parameter_group_name    = "default.mysql5.7"
  db_subnet_group_name    = aws_db_subnet_group.databases.name
  vpc_security_group_ids  = module.network.security_group_ids

  name      = "mavenlink"
  username  = "mavenlink"
  password  = "password"
  port      = 3306

  allocated_storage     = 8
  max_allocated_storage = 40
  storage_type          = "gp2"
  storage_encrypted     = true

  apply_immediately           = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  copy_tags_to_snapshot       = true
  publicly_accessible         = false
  backup_retention_period     = 30

  tags = {
    Name        = "${local.team} ${local.environment} Database"
    Team        = local.team
    Environment = local.environment
  }
}
