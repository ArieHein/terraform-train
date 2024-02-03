# Local Variables
locals {
  resource_group_tags = {
    Project = var.project_name
  }
  resource_tags = {
    Environment = var.environment_name
    CreatedBy   = "Terraform"
  }
}

# Current Connection Config
data "azurerm_client_config" "current" {
}

# Provision a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.project_prefix}-${var.project_location_prefix}-${var.environment_prefix}-rg"
  location = var.project_location
  tags     = merge(local.resource_group_tags, local.resource_tags)
}

# KeyVault Module
module "key_vault" {
  source                = "../modules/key_vault"
  kv_project_prefix     = var.project_prefix
  kv_project_location   = var.project_location_prefix
  kv_environment_prefix = var.environment_prefix
  kv_location           = var.project_location
  kv_resource_group     = azurerm_resource_group.rg.name
  kv_tenant_id          = data.azurerm_client_config.current.tenant_id
  kv_object_id          = data.azurerm_client_config.current.object_id
  kv_tags               = local.resource_tags
}

# App Module
module "app" {
  source                       = "../components/app"
  app_project_prefix     = var.project_prefix
  app_project_location   = var.project_location_prefix
  app_environment_prefix = var.environment_prefix
  app_location           = var.project_location
  app_resource_group     = azurerm_resource_group.rg.name
  app_sql_server_name    = module.db.server_name
  app_sql_database_name  = module.db.sql_database_name
  app_kv_id              = module.key_vault.kv_id
  app_os_name            = "windows"
  app_sku_name           = var.plan_sku_name
  app_worker_count       = var.plan_worker_count
  app_tags               = local.resource_tags
}

# DB Module
module "db" {
  source                       = "../components/db"
  db_project_prefix     = var.project_prefix
  db_project_location   = var.project_location_prefix
  db_environment_prefix = var.environment_name
  db_location           = var.project_location
  db_resource_group     = azurerm_resource_group.rg.name
  db_kv_id              = module.key_vault.kv_id
  db_sql_sku            = var.db_sql_sku
  db_sql_max_size       = var.db_sql_max_size
  db_tags               = local.resource_tags
}