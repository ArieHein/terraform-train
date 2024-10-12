terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=_TF_AzureRMVersion_"
    }
  }
}

provider "azurerm" {
  features {}
}