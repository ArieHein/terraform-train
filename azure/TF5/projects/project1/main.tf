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
  source                = "git::https://example.com/enterprise.git//modules/key_vault"
  kv_project_prefix     = var.project_prefix
  kv_project_location   = var.project_location_prefix
  kv_environment_prefix = var.environment_prefix
  kv_location           = var.project_location
  kv_resource_group     = azurerm_resource_group.rg.name
  kv_tenant_id          = data.azurerm_client_config.current.tenant_id
  kv_object_id          = data.azurerm_client_config.current.object_id
  kv_tags               = local.resource_tags
}

# App stack
module "app" {
  source                   = "git::https://example.com/enterprise.git//stacks/app"
  stack_project_prefix     = var.project_prefix
  stack_project_location   = var.project_location_prefix
  stack_environment_prefix = var.environment_prefix
  stack_location           = var.project_location
  stack_resource_group     = azurerm_resource_group.rg.name
  stack_sql_server_name    = module.db.server_name
  stack_sql_database_name  = module.db.sql_database_name
  stack_kv_id              = module.key_vault.kv_id
  stack_os_name            = "windows"
  stack_sku_name           = var.plan_sku_name
  stack_worker_count       = var.plan_worker_count
  stack_tags               = local.resource_tags
}

# DB stack
module "db" {
  source                   = "git::https://example.com/enterprise.git//stacks/db"
  stack_project_prefix     = var.project_prefix
  stack_project_location   = var.project_location_prefix
  stack_environment_prefix = var.environment_name
  stack_location           = var.project_location
  stack_resource_group     = azurerm_resource_group.rg.name
  stack_kv_id              = module.key_vault.kv_id
  stack_sql_sku            = var.db_sql_sku
  stack_sql_max_size       = var.db_sql_max_size
  stack_tags               = local.resource_tags
}