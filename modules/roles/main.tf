terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.securityadmin]
    }
  }
}

resource "snowflake_role" "role" {
  provider = snowflake.securityadmin
  name     = "${each.value}_${local.env}"
  comment  = "for testing"
  for_each = toset(tolist(local.variables.roles))
}

resource "snowflake_user" "user" {
  provider = snowflake.securityadmin
  name     = each.value
  comment  = "for testing"
  for_each = toset(var.users)
}

resource "snowflake_role_grants" "grants" {
  provider = snowflake.securityadmin
  role_name = each.value.role
  roles     = each.value.grantee
  users     = ["SAYAN"] #Name of user who is the ACCOUNTADMIN.
  for_each  = local.rolemaps
  depends_on = [
    snowflake_role.role,
    snowflake_user.user
  ]
}

resource "snowflake_role_grants" "system_grants" {
  provider = snowflake.securityadmin
  role_name = each.value.role
  roles     = each.value.grantee
  for_each  = local.system_rolemaps
  depends_on = [
    snowflake_role.role
  ]
}