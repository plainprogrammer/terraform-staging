variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = "${var.team}-${var.environment}"
  elasticsearch_version = "7.4"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 16
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  vpc_options {
    subnet_ids          = var.subnet_ids
    security_group_ids  = var.security_group_ids
  }

  tags = {
    Domain      = "${var.team}-${var.environment}"
    Team        = var.team
    Environment = var.environment
  }
}
