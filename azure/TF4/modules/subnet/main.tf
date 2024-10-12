terraform {
  required_version = "=1.9.7"
}

resource "azurerm_subnet" "sub" {
  name                 = "${var.sub_name}-sub"
  resource_group_name  = var.sub_resource_group
  virtual_network_name = var.sub_vnet_name
  address_prefixes     = var.sub_add_prefix
}