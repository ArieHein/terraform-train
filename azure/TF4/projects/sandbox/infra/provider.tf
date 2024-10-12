terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=_TF_AzureRMVersion_"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}