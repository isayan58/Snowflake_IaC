terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      #   configuration_aliases = [snowflake.sysadmin, snowflake.securityadmin, snowflake.sysadmin_qa]
    }
  }
}

provider "snowflake" {
  //required
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = "ap-southeast-1"
  password = var.snowflake_password
  role     = "SYSADMIN"
}

module "database" {
  source   = "./modules/database"
}

module "schema" {
  source = "./modules/schema"
  # depends_on = [
  #   module.database
  # ]
}

module "roles" {
  source = "./modules/roles"
}

module "warehouse" {
  source = "./modules/warehouse"
}

module "grants" {
  source = "./modules/grants"
}