terraform {
  required_version = "=1.9.7"
}

resource "azurerm_sql_database" "mssqldb" {
  name                = "${var.db_name}-sqldb"
  location            = var.db_location
  resource_group_name = var.db_resource_group
  server_name         = var.db_sql_server_id
  max_size_bytes      = var.db_max_size
  sku_name            = var.db_sku_name
  tags                = var.db_tags
}