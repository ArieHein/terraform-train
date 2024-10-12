# Local Variables
locals {
  project_tags = {
    Project = var.project_name
  }
}

# Current Connection Config
data "azurerm_client_config" "current" {
}

# Common KeyVault Reference
data "azurerm_key_vault" "kv" {
  name                = "${var.common_prefix}-${var.project_location_prefix}-common-kv"
  resource_group_name = "${var.common_prefix}-${var.project_location_prefix}-common-rg"
}

# Random User
resource "random_string" "vmuser" {
  length      = 9
  upper       = true
  min_upper   = 3
  lower       = true
  min_lower   = 3
  numeric     = true
  min_numeric = 3
  special     = false
}

# Random Password
resource "random_password" "vmpwd" {
  length           = 16
  upper            = true
  min_upper        = 4
  lower            = true
  min_lower        = 4
  numeric          = true
  min_numeric      = 4
  special          = true
  min_special      = 4
  override_special = "!@#%&*-_=+<>:?"
}

# KeyVault Secrets
module "azurerm_key_vault_secret" "vmadmuser" {
  source       = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fkey_vault_secret"
  name         = "${var.project_prefix}-vmuser"
  value        = random_string.vmuser.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

module "azurerm_key_vault_secret" "vmadmpwd" {
  source       = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fkey_vault_secret"
  name         = "${var.project_prefix}-vmpwd"
  value        = random_password.vmpwd.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Resource Group
module "rg" {
  source      = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fresource_group"
  rg_name     = var.project_prefix
  rg_location = var.project_location
  rg_tags     = local.project_tags
}

module "azurerm_virtual_network" "vnet" {
  source              = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fvirtual_network"
  name                = var.project_prefix
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  address_space       = ["10.0.0.0/16"]
  tags                = local.project_tags
}

module "azurerm_subnet" "subnet" {
  source              = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fsubnet"
  name                 = "internal"
  resource_group_name  = module.rg.rg_name
  virtual_network_name = module.rg.rg_location
  address_prefixes     = ["10.0.2.0/24"]
  tags                 = local.project_tags
}

module "azurerm_windows_virtual_machine_scale_set" "winvmss" {
  source              = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fwindows_virtual_machine_scale_set"
  name                = var.project_prefix
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  sku                 = var.win_sku
  instances           = var.win_instances
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subnet.id
    }
  }

  tags = local.project_tags
}

module "azurerm_linux_virtual_machine_scale_set" "linvmss" {
  source              = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Flinux_virtual_machine_scale_set"
  name                = var.project_prefix
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  sku                 = var.lin_sku
  instances           = var.lin_instances
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"

  source_image_reference {
    publisher = ""
    offer     = ""
    sku       = ""
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subnet.id
    }
  }

  tags = local.project_tags
}