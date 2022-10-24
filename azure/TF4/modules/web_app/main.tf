terraform {
  required_version = "=1.3.3"
}

resource "azurerm_app_service" "webapp" {
  name                = "${var.app_project_prefix}-${var.app_project_location}-${var.app_environment_prefix}-app"
  location            = var.app_location
  resource_group_name = var.app_resource_group
  app_service_plan_id = var.app_plan_id

  site_config {
      always_on = true
  }

  app_settings = {
      "SqlConnectionString" = "Server=tcp:${var.app_sql_server_name},1433;Initial Catalog=${var.app_sql_database_name};Persist Security Info=False;User ID=${random_string.appuser.result};Password=${random_password.apppassword.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
      "InstrumentationKey"  = var.app_instrumentation_key
  }

  tags = var.app_tags
}

# Create Random user and passwords
resource "random_string" "appuser" {
  length = 8
  upper  = true
  lower  = true
  number = true
}

resource "random_password" "apppassword" {
  length = 16
  upper  = true
  lower  = true
  number = true
}

# Store the user and passwords values in KeyVault
resource "azurerm_key_vault_secret" "appuser" {
  name         = "appuser"
  value        = random_string.appuser.result
  key_vault_id = var.app_kv_id
}

resource "azurerm_key_vault_secret" "apppassword" {
  name         = "apppassword"
  value        = random_password.apppassword.result
  key_vault_id = var.app_kv_id
}