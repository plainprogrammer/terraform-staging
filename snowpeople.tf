locals {
  team = "Unicode Snowpeople"
  environment = "Staging"
}

resource "aws_vpc" vpc {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = false

  tags = {
    Name        = "${local.team} ${local.environment}"
    Team        = local.team
    Environment = local.environment
  }
}
