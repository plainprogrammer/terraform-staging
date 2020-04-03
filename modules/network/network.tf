variable "team" {
  type = string
}

variable "environment" {
  type = string
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.team}-${var.environment}"
    Team = var.team
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

resource "aws_subnet" "cache" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Team = var.team
  }
}

resource "aws_subnet" "database-az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/25"
  availability_zone = "us-west-2a"

  tags = {
    Team = var.team
  }
}

resource "aws_subnet" "database-az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.128/25"
  availability_zone = "us-west-2b"

  tags = {
    Team = var.team
  }
}

output "cache_subnet_id" {
  value = aws_subnet.cache.id
}

output "database_subnet_ids" {
  value = [aws_subnet.database-az1.id, aws_subnet.database-az2.id]
}
