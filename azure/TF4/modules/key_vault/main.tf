terraform {
  required_version = "=1.3.3"
}

# Provision a KeyVault
resource "azurerm_key_vault" "kv" {
  name                     = "${var.kv_project_prefix}-${var.kv_project_location_prefix}-${var.kv_environment_prefix}-kv"
  location                 = var.kv_location
  resource_group_name      = var.kv_resource_group
  tenant_id                = var.kv_tenant_id
  purge_protection_enabled = false
  enabled_for_deployment   = true
  sku_name                 = "standard"

  access_policy {
    tenant_id = var.kv_tenant_id
    object_id = var.kv_object_id

    secret_permissions = [
      "get",
      "set",
      "list"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.kv_tags
}