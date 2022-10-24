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
  component_project_prefix     = var.project_prefix
  component_project_location   = var.project_location_prefix
  component_environment_prefix = var.environment_prefix
  component_location           = var.project_location
  component_resource_group     = azurerm_resource_group.rg.name
  component_sql_server_name    = module.db.server_name
  component_sql_database_name  = module.db.sql_database_name
  component_kv_id              = module.key_vault.kv_id
  component_os_name            = "windows"
  component_sku_name           = var.plan_sku_name
  component_worker_count       = var.plan_worker_count
  component_tags               = local.resource_tags
}

# DB Module
module "db" {
  source                       = "../components/db"
  component_project_prefix     = var.project_prefix
  component_project_location   = var.project_location_prefix
  component_environment_prefix = var.environment_name
  component_location           = var.project_location
  component_resource_group     = azurerm_resource_group.rg.name
  component_kv_id              = module.key_vault.kv_id
  component_sql_sku            = var.db_sql_sku
  component_sql_max_size       = var.db_sql_max_size
  component_tags               = local.resource_tags
}