provider "aws" {
  version = "~> 2.0"
  region = "us-west-2"
  shared_credentials_file = "~/.aws/config"
  profile = "okta-dev"
}
