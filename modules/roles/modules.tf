module "user" {
  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }
  source   = "../user"
  for_each = local.users
  user     = each.value
}