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

resource "snowflake_schema" "schema" {
  database            = local.database
  name                = each.value.schema
  comment             = "A schema."
  is_transient        = false
  is_managed          = false
  data_retention_days = 1
  for_each            = local.schema_details
}
