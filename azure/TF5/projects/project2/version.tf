terraform {
  required_version = "1.9.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.6.3"
    }
  }
}