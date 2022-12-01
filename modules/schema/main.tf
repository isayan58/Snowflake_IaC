terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.sysadmin]
    }
  }
}

resource "snowflake_schema" "schema" {
  provider = snowflake.sysadmin
  database            = local.database
  name                = each.value.schema
  comment             = "A schema."
  is_transient        = false
  is_managed          = false
  data_retention_days = 1
  for_each            = local.schema_details
}
