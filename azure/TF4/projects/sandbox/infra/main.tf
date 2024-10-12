# Local Variables
locals {
  project_tags = {
    Project = var.project_name
  }
}

# Current Connection Config
data "azurerm_client_config" "current" {
}

# Resource Group
module "rg" {
  source      = "https://dev.azure.com/OrgName/_git/Infra?path=%2FModules%2Fresource_group"
  rg_name     = var.project_prefix
  rg_location = var.project_location
  rg_tags     = local.project_tags
}
