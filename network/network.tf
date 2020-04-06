resource "aws_vpc" vpc {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = merge(local.common_tags, {
    Name = "${var.team} ${var.environment}"
  })
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {})
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

  tags = merge(local.common_tags, {})
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gateway.id
  }

  tags = merge(local.common_tags, {})
}

resource "aws_subnet" "databases-az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/26"
  availability_zone = "us-west-2a"

  tags = merge(local.common_tags, {})
}

resource "aws_subnet" "databases-az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.64/26"
  availability_zone = "us-west-2b"

  tags = merge(local.common_tags, {})
}

resource "aws_subnet" "databases-az3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.128/26"
  availability_zone = "us-west-2c"

  tags = merge(local.common_tags, {})
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

  tags = merge(local.common_tags, {
    Name = "allow-bigmaven-db-connections"
  })
}
