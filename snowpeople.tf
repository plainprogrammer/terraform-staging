locals {
  team        = "Unicode Snowpeople"
  team_id     = lower(replace(local.team, " ", "-"))
  environment = "Staging"
}

resource "aws_vpc" vpc {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name        = "${local.team} ${local.environment}"
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc.id

  egress {
    rule_no         = 100
    action          = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    icmp_code       = 0
    icmp_type       = 0
    ipv6_cidr_block = ""
  }

  ingress {
    rule_no         = 100
    action          = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    icmp_code       = 0
    icmp_type       = 0
    ipv6_cidr_block = ""
  }

  subnet_ids = [
    aws_subnet.databases-az1.id,
    aws_subnet.databases-az2.id,
    aws_subnet.databases-az3.id
  ]

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gateway.id
  }

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_subnet" "databases-az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/26"
  availability_zone = "us-west-2a"

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_subnet" "databases-az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.64/26"
  availability_zone = "us-west-2b"

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_subnet" "databases-az3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.128/26"
  availability_zone = "us-west-2c"

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_security_group" "bigmaven-sg" {
  name        = "bigmaven-db-connection"
  description = "Allow database connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow-bigmaven-db-connections"
    Team        = local.team
    Environment = local.environment
  }
}

resource "aws_db_subnet_group" "databases" {
  name        = "primary-database-subnet-group"
  subnet_ids  = [
    aws_subnet.databases-az1.id,
    aws_subnet.databases-az2.id,
    aws_subnet.databases-az3.id
  ]

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
  vpc_security_group_ids  = [aws_security_group.bigmaven-sg.id]

  name      = "mavenlink"
  username  = "mavenlink"
  password  = "password"
  port      = 3306

  allocated_storage     = 8
  max_allocated_storage = 40
  storage_type          = "gp2"
  storage_encrypted     = true

  apply_immediately           = false
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
