terraform {
  required_version = "1.9.7"

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

resource "azurerm_resource_group" "rg1" {
  name     = "RG1"
  location = var.resource_group_location
}

resource "azurerm_resource_group" "rg2" {
  name     = "RG2"
  location = var.resource_group_location
}

resource "azurerm_resource_group" "rg3" {
  name     = "RG3"
  location = var.resource_group_location
}

variable "resource_group_location" {
  description = "The Resource Group Location"
  type        = string
  default     = "North Europe"
}