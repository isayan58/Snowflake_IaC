locals {
  # Default values used for deployment logic, the contents of variables.yml would seldom change
  #variables = yamldecode(file("variables.yml"))

  # The input variables to be defined by users are passed through user_input.yml
  user_input = yamldecode(file("./modules/database/user_input.yml"))

  # A list of new databases to be created
  environment = "QA"
  databases = tolist(local.user_input.databases)

  db_map = { for db in local.databases : db.name => {
    name                    = "${db.name}_${local.environment}"
    has_environment_schemas = db.has_environment_schema
  } }

}
