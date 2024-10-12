terraform {
  required_version = "=1.9.7"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${var.sub_prefix}-${var.proj_loc_pre}-rg"
  location = var.rg_location
  tags     = merge(lvar.rg_tags)
}