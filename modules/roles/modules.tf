module "user" {
  source   = "../user"
  for_each = local.users
  user     = each.value
}

# Create the schemas that we need
# module "schema" {
#   source        = "./modules/schema/"
#   for_each      = local.schema_map
#   schema_name   = each.value.name
#   database_name = each.value.database
#   providers = {
#     snowflake.sysadmin      = snowflake.sysadmin
#     snowflake.securityadmin = snowflake.securityadmin
#   }
#   depends_on = [
#     module.database
#   ]
# }

# Create the database that we need
# module "database" {
#   source                  = "./modules/database/"
#   for_each                = local.db_map
#   database_name           = each.value.name
#   has_environment_schemas = each.value.has_environment_schemas
#   providers = {
#     snowflake.sysadmin      = snowflake.sysadmin
#     snowflake.securityadmin = snowflake.securityadmin
#   }
# }

# module "warehouse" {
#   source = "./modules/warehouse/"
# }


# module "grants" {
#   source = "./modules/grants"
# }
