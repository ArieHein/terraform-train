terraform {
  required_version = "=1.9.7"
}

# Provision a Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "${var.plan_name}-plan"
  resource_group_name = var.plan_resource_group
  location            = var.plan_location
  os_type             = var.plan_os_type
  sku_name            = var.plan_sku_name
  worker_count        = var.plan_worker_count
  tags                = var.plan_tags
}