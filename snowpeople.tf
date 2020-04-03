provider "aws" {
  version = "~> 2.0"
  region = "us-west-2"
  shared_credentials_file = "~/.aws/config"
  profile = "okta-dev"
}

locals {
  team        = "unicode-snowpeople"
  environment = "staging"
}

module "network" {
  source = "./modules/network"

  team        = local.team
  environment = local.environment
}

module "cache" {
  source = "./modules/cache"

  team        = local.team
  environment = local.environment
  subnet_id   = module.network.cache_subnet_id
}

module "database" {
  source = "./modules/database"

  team        = local.team
  environment = local.environment
  subnet_ids  = module.network.database_subnet_ids
}
