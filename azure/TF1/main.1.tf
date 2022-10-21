terraform {
  required_version = "1.3.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}

# Provision a Windows Web App to host our code
resource "azurerm_windows_web_app" "webapp" {
  name                = "MyAppSrv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}

# Provision a Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "MyAppSrvPlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}

# Provision a Resoure Group
resource "azurerm_resource_group" "rg" {
  name     = "MyRG"
  location = "North Europe"
}