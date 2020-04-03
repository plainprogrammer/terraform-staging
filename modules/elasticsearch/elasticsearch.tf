variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = "${var.team}-${var.environment}"
  elasticsearch_version = "1.5"

  cluster_config {
    instance_type = "t2.micro.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 16
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  vpc_options {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Domain = "${var.team}-${var.environment}"
    Team = var.team
  }
}
