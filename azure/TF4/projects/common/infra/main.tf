# Local Variables
locals {
  project_tags = {
    Project = var.project_name
  }
}

# Current Connection Config
data "azurerm_client_config" "current" {
}

# Resource Group
module "rg" {
  source       = "git::https://token:__SYSTEM_ACCESSTOKEN__@dev.azure.com/OrgName/_git/Infra//modules/resource_group"
  proj_loc_pre = "${lookup(var.project_location_prefix, var.project_location)}"
  rg_name      = var.project_prefix
  rg_location  = var.project_location
  rg_tags      = local.project_tags
}

# Key Vault
module "kv" {
  source         = "git::https://token:__SYSTEM_ACCESSTOKEN__@dev.azure.com/OrgName/_git/Infra//modules/key_vault"
  proj_loc_pre   = "${lookup(var.project_location_prefix, var.project_location)}"
  rg_name        = module.rg.resource_group_name
  rg_location    = module.rg.resource_group_location
  kv_name        = var.project_prefix
  kv_sku         = var.key_vault_sku
  kv_enable_rbac = false
  tenant_id      = data.azurerm_client_config.current.tenant_id
  kv_tags        = local.project_tags
}

module "kvpol" {
  source            = "git::https://token:__SYSTEM_ACCESSTOKEN__@dev.azure.com/OrgName/_git/Infra//modules/key_vault_access_policy"
  kv_id             = module.kv.kv_id
  kvpol_tenant_id   = data.azurerm_client_config.current.tenant_id
  kvpol_object_id   = data.azurerm_client_config.current.object_id
  kvpol_secret_perm = var.kv_secret_perm
  kvpol_key_perm    = var.kv_key_perm
  kvpol_cert_perm   = var.kv_cert_perm
}