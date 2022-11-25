terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}

provider "snowflake" {
  //required
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = "ap-southeast-1"
  password = var.snowflake_password
  role     = "SECURITYADMIN"
}

resource "snowflake_role" "role" {
  name     = "${each.value}_${local.env}"
  comment  = "for testing"
  for_each = toset(tolist(local.variables.roles))
}

resource "snowflake_user" "user" {
  name     = each.value
  comment  = "for testing"
  for_each = toset(var.users)
}

resource "snowflake_role_grants" "grants" {
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
  role_name = each.value.role
  roles     = each.value.grantee
  for_each  = local.system_rolemaps
  depends_on = [
    snowflake_role.role
  ]
}
