terraform {
  backend "s3" {
    bucket = "snowpeople-terraform-staging"
    key    = "terraform-state"
    region = "us-west-2"
  }
}
