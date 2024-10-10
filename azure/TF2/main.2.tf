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

resource "azurerm_resource_group" "rg" {
  for_each = toset(var.resource_group_names)
  name     = each.value
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