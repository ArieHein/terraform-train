terraform {
  required_version = "=1.9.7"
}

# Provision a Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "${var.plan_project_prefix}-${var.plan_project_location_prefix}-${var.plan_environment_prefix}-plan"
  location            = var.plan_location
  resource_group_name = var.plan_resource_group
  os_name             = var.plan_os_name
  sku_name            = var.plan_sku_name
  worker_count        = var.plan_worker_count
  tags                = var.plan_tags
}