module "database" {
  source   = "./modules/database"
  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
  }
  depends_on = [
    module.roles
  ]
}

module "schema" {
  source = "./modules/schema"
  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
  }
  depends_on = [
    module.database
  ]
}

module "roles" {
  source = "./modules/roles"
  providers = {
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "warehouse" {
  source = "./modules/warehouse"
  providers = {
    snowflake.sysadmin = snowflake.sysadmin
  }
  depends_on = [
    module.roles
  ]
}

module "grants" {
  source = "./modules/grants"
  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
    snowflake.securityadmin = snowflake.securityadmin
    snowsql.securityadmin = snowsql.securityadmin
  }
  depends_on = [
    module.roles,
    module.warehouse,
    module.schema
  ]
}