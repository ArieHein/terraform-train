terraform {
  required_version = "=1.9.7"
}

# Provision a KeyVault
resource "azurerm_key_vault" "kv" {
  name                     = var.kv_name
  resource_group_name      = var.kv_resource_group
  location                 = var.kv_location
  tenant_id                = var.kv_tenant_id
  sku_name                 = var.kv_sku_name

  access_policy {
    tenant_id = var.kv_tenant_id
    object_id = var.kv_object_id

    secret_permissions = [
      "get",
      "set",
      "list"
    ]

    key_permissions = []
    certificate_permissions = []
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.kv_tags
}