terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.sysadmin, snowflake.securityadmin]
    }
    snowsql = {
      source  = "aidanmelen/snowsql"
      version = ">= 0.1.0"
      configuration_aliases = [snowsql.securityadmin]
    }
  }
}

#Snowflake current table grants
resource "snowsql_exec" "dcl" {
  provider = snowsql.securityadmin
  for_each = local.privilegemapcurrenttable

  name = "${each.key}_all_grant"

  create {
    statements = <<-EOT
    GRANT ${each.value.privilege} ON ALL TABLES IN SCHEMA ${each.value.database}.${each.value.schema} TO ROLE ${each.value.role};
    GRANT ${each.value.privilege} ON ALL VIEWS IN SCHEMA ${each.value.database}.${each.value.schema} TO ROLE ${each.value.role};
    GRANT ${each.value.privilege} ON ALL MATERIALIZED VIEWS IN SCHEMA ${each.value.database}.${each.value.schema} TO ROLE ${each.value.role};
    EOT
  }

  delete {
    statements = <<-EOT
    REVOKE ${each.value.privilege} ON ALL TABLES IN SCHEMA ${each.value.database}.${each.value.schema} FROM ROLE ${each.value.role};
    REVOKE ${each.value.privilege} ON ALL VIEWS IN SCHEMA ${each.value.database}.${each.value.schema} FROM ROLE ${each.value.role};
    REVOKE ${each.value.privilege} ON ALL MATERIALIZED VIEWS IN SCHEMA ${each.value.database}.${each.value.schema} FROM ROLE ${each.value.role};
    EOT
  }
}

resource "snowflake_database_grant" "grant" {
  provider = snowflake.securityadmin
  for_each      = { for entry in local.privilegemaps : "${entry.schema}.${entry.privilege}" => entry }
  database_name = "TEST_1_${local.env}"
  privilege     = each.value.privilege
  roles         = ["${each.value.schema}_RO_${local.env}", "${each.value.schema}_RW_${local.env}", "${each.value.schema}_FR_${local.env}"]
}

resource "snowflake_database_grant" "grant_sys" {
  provider = snowflake.securityadmin
  for_each      = local.privilegemaps_db
  database_name = each.value.database
  privilege     = each.value.privilege
  roles         = tolist([each.value.role])
  depends_on = [
    snowflake_database_grant.grant
  ]
}

resource "snowflake_schema_grant" "grant_schema" {
  provider = snowflake.securityadmin
  for_each      = { for entry in local.privilegemapschema : "${entry.schema}.${entry.privilege}" => entry }
  database_name = "TEST_1_${local.env}"
  privilege     = each.value.privilege
  schema_name   = each.value.schema
  roles         = ["${each.value.schema}_RO_${local.env}", "${each.value.schema}_RW_${local.env}", "${each.value.schema}_FR_${local.env}"]
  depends_on = [
    snowflake_database_grant.grant
  ]
}

resource "snowflake_table_grant" "read_permissions" {
  # We need a map to use for_each, so we convert our list into a map by adding a unique key:
  provider = snowflake.securityadmin
  for_each      = { for entry in local.schema_privileges : "${entry.schema}.${entry.privilege}" => entry }
  database_name = "TEST_1_${local.env}"
  privilege     = "SELECT"
  roles         = ["${each.value.schema}_RO_${local.env}", "${each.value.schema}_RW_${local.env}", "${each.value.schema}_FR_${local.env}"]
  schema_name   = each.value.schema
  on_future     = true
  depends_on = [
    snowflake_schema_grant.grant_schema
  ]
}

resource "snowflake_table_grant" "write_permissions" {
  # We need a map to use for_each, so we convert our list into a map by adding a unique key:
  provider = snowflake.securityadmin
  for_each      = { for entry in local.schema_privileges : "${entry.schema}.${entry.privilege}" => entry }
  database_name = "TEST_1_${local.env}"
  privilege     = each.value.privilege
  roles         = ["${each.value.schema}_RW_${local.env}"]
  schema_name   = each.value.schema
  on_future     = true
  depends_on = [
    snowflake_schema_grant.grant_schema
  ]
}

resource "snowflake_schema_grant" "engineer_permissions" {
  # We need a map to use for_each, so we convert our list into a map by adding a unique key:
  provider = snowflake.securityadmin
  for_each      = { for entry in local.engineer_privilege : "${entry.schema}.${entry.privilege}" => entry }
  database_name = "TEST_1_${local.env}"
  privilege     = each.value.privilege
  roles         = ["FULL_RW_DR_${local.env}"]
  schema_name   = each.value.schema
  # on_future     = true
  depends_on = [
    snowflake_schema_grant.grant_schema
  ]
}
