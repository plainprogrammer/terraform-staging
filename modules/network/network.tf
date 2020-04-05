variable "team" {
  type = string
}

variable "environment" {
  type = string
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${var.team}-${var.environment}"
    Team        = var.team
    Environment = var.environment
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

resource "aws_subnet" "cache" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}

resource "aws_subnet" "databases-az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/26"
  availability_zone = "us-west-2a"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}

resource "aws_subnet" "databases-az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.64/26"
  availability_zone = "us-west-2b"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}

resource "aws_subnet" "databases-az3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.128/26"
  availability_zone = "us-west-2c"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}

resource "aws_subnet" "elasticsearch" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}

output "cache_subnet_id" {
  value = aws_subnet.cache.id
}

output "database_subnet_ids" {
  value = [aws_subnet.databases-az1.id, aws_subnet.databases-az2.id, aws_subnet.databases-az3.id]
}

output "elasticsearch_subnet_ids" {
  value = [aws_subnet.elasticsearch.id]
}
