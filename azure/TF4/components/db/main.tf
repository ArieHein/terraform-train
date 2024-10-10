terraform {
  required_version = "=1.9.7"
}

module "sql_server" {
  source                 = "../modules/sql_server"
  sql_project_prefix     = var.component_project_prefix
  sql_project_location   = var.component_project_location
  sql_environment_prefix = var.component_environment_prefix
  sql_location           = var.component_location
  sql_resource_group     = var.component_resource_group
  sql_kv_id              = var.component_kv_id
  sql_tags               = var.component_tags
}

module "sql_database" {
  source                = "../modules/sql_database"
  db_project_prefix     = var.component_project_prefix
  db_project_location   = var.component_project_location
  db_environment_prefix = var.component_environment_prefix
  db_location           = var.component_location
  db_resource_group     = var.component_resource_group
  db_sql_server_id      = module.sql_server.server_id
  db_sql_sku            = var.component_sql_sku
  db_sql_max_size       = var.component_sql_max_size
  db_tags               = var.component_tags
}