terraform {
  required_version = "1.3.3"

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