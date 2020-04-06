variable "team" {
  type = string
}

variable "environment" {
  type = string
}

locals {
  common_tags = {
    Team        = var.team
    Environment = var.environment
  }
}
