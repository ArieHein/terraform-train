terraform {
  required_version = "=1.9.7"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "${var.func_name}-func"
  resource_group_name        = var.func_resource_group
  location                   = var.func_location
  service_plan_id            = var.func_plan_id
  storage_account_name       = var.func_sta_name
  storage_account_access_key = var.func_sta_access_key
  site_config {}
  tags                       = var.func_tags
}