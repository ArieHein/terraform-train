terraform {
  required_version = "1.7.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  count    = length(var.resource_group_names)
  name     = var.resource_group_names[count.index]
  location = var.resource_group_location
}

variable "resource_group_location" {
  description = "The Resource Group Location"
  type        = string
  default     = "North Europe"
}

variable "resource_group_names" {
  description = "The Names of all Resource Groups"
  type        = list(string)
  default     = ["RG1", "RG2", "RG3"]
}