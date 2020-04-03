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
