terraform {
  required_version = "=1.9.7"
}

resource "azurerm_storage_account" "sta" {
  name                     = "${var.sta_name}sta"
  resource_group_name      = var.sta_resource_group
  location                 = var.sta_location
  account_tier             = var.sta_tier
  account_kind             = var.sta_kind
  account_replication_type = var.sta_replication_type
  min_tls_version          = var.sta_min_tls
  tags                     = var.sta_tags
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.sta_containers)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.sta.name
  container_access_type = var.sta_container_access
}