terraform {
  backend "s3" {
    bucket = "snowpeople-terraform-staging"
    key    = "terraform-state"
    region = "us-west-2"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "snowpeople-terraform-staging"
  acl           = "private"
  force_destroy = false
  region        = "us-west-2"
  request_payer = "BucketOwner"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Team        = local.team
    Environment = local.environment
  }
}
