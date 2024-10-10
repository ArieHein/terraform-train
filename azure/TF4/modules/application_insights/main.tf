terraform {
  required_version = "=1.9.7"
}

# Provision an Application Insights
resource "azurerm_application_insights" "ais" {
  name                = "${var.ais_project_prefix}-${var.ais_project_location_prefix}-${var.ais_environment_prefix}-ais"
  location            = var.ais_location
  resource_group_name = var.ais_resource_group
  application_type    = "web"
  tags                = var.ais_tags
}