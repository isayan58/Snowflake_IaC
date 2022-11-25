locals {
  # Default values used for deployment logic, the contents of variables.yml would seldom change
  variables = yamldecode(file("./modules/grants/variables.yml"))
  #environment
  env = local.variables.environments

  schemas       = ["SCD_1", "SCD_2", "SCD_3", "SCD_4"]
  privileges_db = ["USAGE"]

  privilegemaps_db = { for v in local.variables.privilegemap_db : v.privilege => {
    privilege = v.privilege
    role      = "${v.role}_${local.env}"
    database  = "${v.database}_${local.env}"
    }
  }

  privilegemaps = distinct(flatten([
    for schema in local.schemas : [
      for privilege in local.privileges_db : {
        privilege = privilege
        schema    = schema
      }
    ]
  ]))

  privilegemapschema = distinct(flatten([
    for schema in local.schemas : [
      for privilege in local.privileges_db : {
        privilege = privilege
        schema    = schema
      }
    ]
  ]))

  privileges = [
    "INSERT", "UPDATE", "DELETE", "TRUNCATE"
  ]

  schema_privileges = distinct(flatten([
    for schema in local.schemas : [
      for privilege in local.privileges : {
        privilege = privilege
        schema    = schema
      }
    ]
  ]))

  engineer_privileges = toset(tolist(["CREATE TABLE",
    "CREATE MATERIALIZED VIEW",
    "CREATE TAG",
    "CREATE TASK",
    "CREATE ROW ACCESS POLICY",
    "CREATE PROCEDURE",
    "CREATE MASKING POLICY",
    "USAGE",
    "CREATE VIEW",
    "CREATE TEMPORARY TABLE",
    "ADD SEARCH OPTIMIZATION",
    "MODIFY",
    "MONITOR",
  "OWNERSHIP"]))


  engineer_privilege = distinct(flatten([
    for schema in local.schemas : [
      for privilege in local.engineer_privileges : {
        privilege = privilege
        schema    = schema
      }
    ]
  ]))

  privilegemapcurrenttable = { for v in local.variables.privilegemap_current_table : v.role => {
    privilege = join(", ", tolist(v.privilege))
    role      = "${v.role}_${local.env}"
    database  = "${v.database}_${local.env}"
    schema    = v.schema
    }
  }

}
