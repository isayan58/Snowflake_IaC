terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
      configuration_aliases = [snowflake.sysadmin]
    }
  }
}

resource "snowflake_warehouse" "wh" {
  provider = snowflake.sysadmin
  name                = "${each.value.name}_WH"
  comment             = "Creating warehouse."
  warehouse_size      = each.value.size
  auto_resume         = true
  max_cluster_count   = each.value.max
  min_cluster_count   = each.value.min
  initially_suspended = true
  for_each            = local.warehouse_map
}

resource "snowflake_warehouse_grant" "wh_grant" {
  provider = snowflake.sysadmin
  warehouse_name = "${each.value.name}_WH"
  privilege      = "USAGE"
  roles = ["${each.value.name}_RO_${local.env}", "${each.value.name}_RW_${local.env}",
  "${each.value.name}_FR_${local.env}"]
  with_grant_option = false
  for_each          = local.warehouse_map
  depends_on = [
    snowflake_warehouse.wh
  ]
}
