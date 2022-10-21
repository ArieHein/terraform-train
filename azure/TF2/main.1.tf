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
  default     = ["RG1","RG2","RG3"]
}