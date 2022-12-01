terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.securityadmin]
    }
  }
}

locals {
  env = "QA"
}

resource "snowflake_user" "user" {
  #"Creating new users as specified in user_input.yml"
  provider = snowflake.securityadmin
  name                 = "${var.user.username}_${local.env}"
  login_name           = "${var.user.username}_${local.env}"
  display_name         = "${var.user.username}_${local.env}"
  default_role         = "PUBLIC"
  password             = var.snowflake_password
  must_change_password = true
}

resource "snowflake_role_grants" "grants" {
  #"Granting roles to new or existing users, as specified in user_input.yml"
  provider = snowflake.securityadmin
  for_each   = toset(var.user.roles)
  role_name  = "${each.key}_${local.env}"
  users      = ["${var.user.username}_${local.env}"]
  depends_on = [snowflake_user.user]
}
