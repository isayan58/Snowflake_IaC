locals {
  # Default values used for deployment logic, the contents of variables.yml would seldom change
  variables = yamldecode(file("./modules/schema/variables.yml"))

  #environment
  env      = local.variables.environments
  database = "${local.variables.database}_${local.env}"

  schema_details = { for sc in local.variables.schema : sc => {
    schema = sc
  } }

}
