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

resource "aws_db_parameter_group" "import-mysql57" {
  name        = "import-mysql57"
  description = "Custom parameters for supporting large imports, like backup restoration."
  family      = "mysql5.7"

  parameter {
    apply_method = "immediate"
    name         = "max_allowed_packet"
    value        = "1073741824" # Maximum Value
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true
  subnet_id                   = element(module.network.subnet_ids, 1)
  user_data                   = file("${path.module}/bastion.user-data")
  vpc_security_group_ids      = [module.network.bastion-security_group_id]

  tags = {
    Name        = "${local.team} ${local.environment} Bastion Host"
    Team        = local.team
    Environmen  = local.environment
  }
}
