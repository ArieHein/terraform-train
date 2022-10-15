terraform {
  required_version = "1.3.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.26.0"
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
  location            = "North Europe"
  resource_group_name = "MyRG"
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}

# Provision a Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "MyAppSrvPlan"
  location            = "North Europe"
  resource_group_name = "MyRG"
  os_type             = "Windows"
  sku_name            = "B1"
}

# Provision a Resoure Group
resource "azurerm_resource_group" "rg" {
  name     = "MyRG"
  location = "North Europe"
}