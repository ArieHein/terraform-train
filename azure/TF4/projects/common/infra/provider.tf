terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=__TF_AzureRMVersion__"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}