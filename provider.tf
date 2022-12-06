terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
    snowsql = {
      source  = "aidanmelen/snowsql"
      version = ">= 0.1.0"
    }
  }
}

provider "snowflake" {
  alias    = "securityadmin"
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region
  password = var.snowflake_password
  role     = "SECURITYADMIN"
}

provider "snowflake" {
  alias    = "useradmin"
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region
  password = var.snowflake_password
  role     = "USERADMIN"
}

provider "snowflake" {
  alias    = "sysadmin"
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region
  password = var.snowflake_password
  role     = "SYSADMIN"
}

provider "snowsql" {
  //required
  alias = "securityadmin"
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region
  password  = var.snowflake_password
  role      = "SECURITYADMIN"
  warehouse = "TEST_WH"
}