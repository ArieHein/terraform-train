terraform {
  required_version = "=1.9.7"
}

# Local Variables
locals {
  resource_tags = {
    CreatedBy = "Terraform"
  }
}
resource "azurerm_function_app" "func" {
  name                       = "${var.func_name}-plan"
  resource_group_name        = var.func_resource_group
  location                   = var.func_location
  app_service_plan_id        = var.func_plan_id
  storage_account_name       = var.func_sta_name
  storage_account_access_key = var.func_sta_access_key
  os_type                    = var.func_os_type
  tags                       = merge(local.resource_tags, var.func_tags)
}