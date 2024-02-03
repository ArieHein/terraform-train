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

terraform {
  backend "azurerm" {
    // You have to use a pre-created Resource Group and Storage Account to host the state file.
    resource_group_name  = "myTFStateRG"
    storage_account_name = "myStorageAccount"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

# Current Connection Config
data "azurerm_client_config" "current" {
}

# Provision a Resoure Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-rg"
  location = var.resource_group_location
}

# Provision a Key Vault
resource "azurerm_key_vault" "kv" {
  name                = "${var.resource_prefix}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "set",
      "list"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# Create Random values for the SQL Server Admin
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

# Create Random values for the SQL Server Application Access
resource "random_string" "appuser" {
  length = 8
  upper  = true
  lower  = true
  numeric = true
}

resource "random_password" "apppassword" {
  length = 16
  upper  = true
  lower  = true
  numeric = true
}

# Store the User and Password values as Secrets in the Key Vault
resource "azurerm_key_vault_secret" "sqladmuser" {
  name         = "sqladmuser"
  value        = random_string.sqladminuser.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sqladmpassword" {
  name         = "sqladmpassword"
  value        = random_password.sqladminpassword.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "appuser" {
  name         = "appuser"
  value        = random_string.appuser.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "apppassword" {
  name         = "apppassword"
  value        = random_password.apppassword.result
  key_vault_id = azurerm_key_vault.kv.id
}

# Provision a Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "${var.resource_prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = var.plan_sku_name
}

# Provision a Windows Web App to host our code
resource "azurerm_windows_web_app" "webapp" {
  name                = "${var.resource_prefix}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    "SqlConnectionString" = "Server=tcp:${azurerm_sql_server.mssql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.mssqldb.name};Persist Security Info=False;User ID=${random_string.appuser.result};Password=${random_password.apppassword.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    "InstrumentationKey"  = azurerm_application_insights.ais.id
  }
}

# Provision an Application Insight instance
resource "azurerm_application_insights" "ais" {
  name                = "${var.resource_prefix}-appi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# Provision a managed SQL Server
resource "azurerm_mssql_server" "mssql" {
  name                         = "${var.resource_prefix}-sql"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "12.0"
  administrator_login          = random_string.sqladminuser.result
  administrator_login_password = random_password.sqladminpassword.result
}

# Provision a managed SQL Database
resource "azurerm_mssql_database" "db" {
  name        = "${var.resource_prefix}-sqldb"
  server_id   = azurerm_mssql_server.mssql.id
  sku_name    = var.db_sql_sku
  max_size_gb = var.db_sql_max_size
}

# Add a SQL Firewall Rule to Allow Azure Services access
resource "azurerm_mssql_firewall_rule" "mssqlfwrule" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}