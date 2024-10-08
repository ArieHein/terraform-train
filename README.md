# Terraform Training

These are simple training sessions in Terraform for both Azure and AWS.

All the base concepts are described in the Azure folder. The AWS folder contains
examples of specific resources creation.

The code examples are based on Terraform 1.3.x and include some of the new syntax and functionalities. The code examples for Azure, are based on version 3.x of the provider. The code examples for AWS, are based on version 4.x of the provider. Both at the version available at the moment of creating this.

Some of the examples given are very simple and not necessarily the most secured ones. It is recommended that you follow best practices from each cloud provider when dealing with segmentation of networks, service identities, network security or other security considerations, unless I mention them myself.

By no mean, is this the only way to structure your Terraform solution. There are two main patterns that I have seen and created for myself and they all evolve around the scale of the project

As you will see, the chapters include a gradual increase of complexity both from the infrastructure side but also from the maintainers point of view. I tried to make the structures as easier to manage and follow but still you might find other structures that fit you, your team, your infrastructure, your organization structure etc.

## Future Plans

Additional chapters (WIP)

- Create a secure Azure design
- Create a complete Azure Landing Zone Chapter
- Create a secure AWS design
- Create a complete AWS Landing Zone Chapter

- Create a CICD pipeline chapter
- Azure DevOps
- GitHub Actions

## Azure

### TF1

Initial. Hardcoded values. Interpolation.

### TF2

multiple resource at same time

### TF3

Small to Medium project, start using backend for state file

### TF4

Medium to Big project

### TF5

Big to Very Big projects

## How to (Azure)

- Login to Azure

    **az login**

- Create a new Resource Group in a location given a name

   ```powershell
    az group create -l northeu -n terraform-rg
   ```

- The returned message will be a json that includes the resource group id (the long descriptor that includes the subscription id), the location and under properties will hold the provisioningState - "Succeeded" when it did.

- We create a service principle for the pipelines and allow it contributor role for the resource group using the resource group id

   ```powershell
    az ad sp create-for-rbac -n terraform-rg -role contributor --scopes (the id value)
   ```

- This will create a service principle (noted as AppID) and will show us the tenantID in which it was create together with a password which is required for creating service connections in Azure DevOps.

- Now we need to create a Storage Account to hold the state file

   ```powershell
    az storage account create --resource-group terraform-rg --name tfstorage --sku Standard_LRS --encryption-services blob
   ```

- The returned message will be a json with 2 keys with full permissions that were created for the storage account. We will need to use one of those to create a container in the storage account.

   ```powershell
    az storage container create --name tfcontainer --account-name tfstorage -account-key (the key value)
   ```

- Create a service connection in Azure DevOps.

## General - Links

<https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage>

<https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure>

<https://learn.hashicorp.com/terraform?track=azurerm>

<https://thorsten-hans.com/terraform-the-definitive-guide-for-azure-enthusiasts>

## Terraform Changes

This chapter is about the upcoming changes to both the Terraform engine and the AzureRM Provider.
Additionally, an ongoing effort by Microsoft that is well worth to keep track of and that is Microsoft Verified Modules.

Links to both, towards the end of this document.

### AzureRM 3.0+

In AzureRM provider version 3.0 and onward, Microsoft has split the App Service object and the Function App to be based on their kind - Windows or Linux and the App Service Plan resource name was changed to Service Plan.

***Note*** that version 4.0 of the Provider will be released towards the end of 2022 or start of 2023.

Here is an example of an App Service Plan, before 3.0

```terraform
resource "azurerm_app_service_plan" "asp" {
    name                = "${var.resource_prefix}-plan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "Windows"

    sku {
        tier = "Standard"
        size = "S1"
    }
}
```

Here is the same resource, after 3.0

```terraform
resource "azurerm_service_plan" "asp" {
    name                = "${var.resource_prefix}-plan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "Windows"

    sku {
        tier = "Standard"
        size = "S1"
    }
}
```

You can see that the resource name changes from **azurerm_app_service_plan** to **azurerm_service_plan**

Here is an example for App Service, before 3.0

```terraform
resource "azurerm_app_service" "webapp" {
  name                = "${var.resource_prefix}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
      always_on = true
  }
}
```

Here is the same resource, after 3.0

```terraform
resource "azurerm_windows_web_app" "webapp" {
  name                = "${var.resource_prefix}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
      always_on = true
  }
}
```

You can see that the resource name changes from **azurerm_app_service** to **azurerm_windows_web_app**

Look at the links section and read more about the changes.

### Terraform Engine 1.2

While variable validation existed since version 0.13, in the version 1.2 we now have a way to perform Pre and Post checks on our code
Validation allows us to force a simple "policy" as to the content of variable values supplied and becomes highly important when working on a complex structure where modules might be created by a different team and potentially in a different repository all together.

In version 1.2 we can now force rules for resources, data sources and outputs. Precondition checks can check values from other data sources for example and should be used to check an assumption. Postcondition checks can check values of resources after they were applied, for example making sure a storage account was created with no public access or a VM has been assigned a Public IP before additional resources will be applied that depend on it.

### Microsoft Verified Modules

While Microsoft is maintaining, together with Hashicorp, the AzureRM provider very actively, until now, modules were either created manually or introduced via the 3rd party providers and modules from the Terraform Registry <https://registry.terraform.io/>.

Microsoft  have released quite a few modules <https://registry.terraform.io/browse/modules?provider=azurerm>, fully maintained and supported so all we need would be to point to their repository and use their versioning schema to pin module versions. This will also hopefully allow modules keeping synced with their AzureRM provider release cadence alleviating some of the pain points of maintaining our own modules between provider changes.

### Terraform Changes - Links

AzureRM Provider 3.0 Upgrade Guide <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/3.0-upgrade-guide>

Terraform Engine 1.2 Custom Condition Check <https://www.terraform.io/language/expressions/custom-conditions#preconditions-and-postconditions>

Azure Terraform Verified Modules <https://azure.github.io/Azure-Verified-Modules/>

## How To (AWS)
