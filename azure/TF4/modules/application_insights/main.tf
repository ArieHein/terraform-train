terraform {
  required_version = "=1.9.7"
}

# Provision an Application Insights
resource "azurerm_application_insights" "ais" {
  name                = "${var.ais_name}-ais"
  location            = var.ais_location
  resource_group_name = var.ais_resource_group
  application_type    = var.ais_type
  workspace_id        = azurerm_log_analytics_workspace.law.id
  tags                = var.ais_tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.ais_name}-law"
  resource_group_name = var.ais_resource_group
  location            = var.ais_location
  sku                 = var.ais_sku
  tags                = var.ais_tags
}