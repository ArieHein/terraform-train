terraform {
  required_version = "=1.9.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Provision a Web App to host our code
resource "azurerm_windows_web_app" "webapp" {
  name                = "MyAppSrv"
  location            = "North Europe"
  resource_group_name = "MyRG"
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}

# Provision a Windows Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "MyAppSrvPlan"
  location            = "North Europe"
  resource_group_name = "MyRG"
  os_type             = "Windows"
  sku_name            = "B1"
}

# Provision a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "MyRG"
  location = "North Europe"
}