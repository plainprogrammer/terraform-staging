variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

resource "aws_elasticache_subnet_group" "cache-subnet" {
  name       = "cache-subnet"
  subnet_ids = [var.subnet_id]
}
