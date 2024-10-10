terraform {
  required_version = "=1.9.7"
}

resource "azurerm_sql_server" "mssql" {
  name                         = "${var.sql_project_prefix}-${var.sql_project_location}-${var.sql_environment_prefix}-sql"
  location                     = var.sql_location
  resource_group_name          = var.sql_resource_group
  version                      = "12.0"
  administrator_login          = random_string.sqladminuser.result
  administrator_login_password = random_password.sqladminpassword.result
  tags                         = var.sql_tags
}

# Create Random user and passwords
resource "random_string" "sqladminuser" {
  length = 8
  upper  = true
  lower  = true
  numeric = true
}

resource "random_password" "sqladminpassword" {
  length = 16
  upper  = true
  lower  = true
  numeric = true
}

# Store the user and passwords values in KeyVault
resource "azurerm_key_vault_secret" "sqladmuser" {
  name         = "sqladmuser"
  value        = random_string.sqladminuser.result
  key_vault_id = var.sql_kv_id
}

resource "azurerm_key_vault_secret" "sqladmpassword" {
  name         = "sqladmpassword"
  value        = random_password.sqladminpassword.result
  key_vault_id = var.sql_kv_id
}

resource "azurerm_mssql_firewall_rule" "fwrule" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}