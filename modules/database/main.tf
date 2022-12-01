terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.sysadmin]
    }
  }
}

resource "snowflake_database" "this" {
  provider = snowflake.sysadmin
  name     = each.value.name
  for_each = local.db_map
}