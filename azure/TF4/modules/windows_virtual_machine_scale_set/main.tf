terraform {
  required_version = "=1.9.7"
}

# Local Variables
locals {
  resource_tags = {
    CreatedBy = "Terraform"
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = var.vmss_resource_group
  location            = var.vmss_location
  sku                 = var.vmss_sku
  instances           = var.vmss_count
  admin_username      = var.vmss_aduser
  admin_password      = var.vmss_adpwd

  source_image_reference {
    publisher = var.vmss_publisher
    offer     = var.vmss_offer
    sku       = var.vmss_sku
    version   = var.vmss_version
  }

  os_disk {
    storage_account_type = var.vmss_sta_type
    caching              = var.vmss_caching
  }

  network_interface {
    name    = var.vmss_nic_name
    primary = var.vmss_nic_primary

    ip_configuration {
      name      = var.vmss_ipconfig_name
      primary   = var.vmss_ipconfig_primary
      subnet_id = var.vmss_subnet_id
    }
  }

  tags = var.vmss_tags
}