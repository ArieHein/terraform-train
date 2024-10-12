terraform {
  required_version = "=1.9.7"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "${var.vnet_name}-vnet"
    resource_group_name = var.vnet_resource_group
    location            = var.vnet_location
    address_space       = var.vnet_address_space
    tags                = var.vnet_tags
}