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

resource "snowflake_database" "this" {
  name     = each.value.name
  for_each = local.db_map
}