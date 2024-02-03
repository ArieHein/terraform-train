# TF1

***Note: If you try to run terraform in this folder, it will error out as terraform will try to run both *.tf files. Rename one of the files or remove it to avoid errors***

## Overview

This is a simple terraform script with a purpose of creating a Resource Group, a Web App and a Service Plan.

All values are hardcoded. In later examples we will use variables.

The first section is a declaration of the version of Terraform engine that we require. This is not mandatory in this scenario. Terraform will use the version found on the machine, based on the PATH environment variable.

However, if you are using features that were implemented in a specific version and that version is not available on the machine, an error will be shown.

***Tip! When running a Terraform script as part of a pipeline, make sure to first install the required Terraform CLI. Do not take for granted that the version of Terraform you need is indeed installed.***

We also use this section to declare the required providers, source and versions that are needed for this.

```terraform
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
```

The second section is a declaration of each provider that will be used, with any initial feature settings if it is required. For instance, for the AzureRM provider, you **have** to specify the **features** declaration even if it is empty.

```terraform
provider "azurerm" {
  features {}
}
```

The third section will describe all the resources we are going to create.

## Resource Group

All resources created in a **Subscription**, must be created inside one **Resource Group** or more. A Resource Group serves as a security boundary and an operation boundary as each Resource Group must reside in one of the regional locations of Azure datacenters. This has implications on resources that require high availability but also if there are requirements to have the resources closer to the end users for data sovereignty.

Each Resource Group requires a unique Name, within the Subscription, and a Location.

```terraform
# Provision a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "MyRG"
  location = "North Europe"
}
```

For additional information, view: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group>

The syntax we see here consists of the keyword **resource**, the type of the resource from the Providers we declared - **azurerm_resource_group** and an instance of this resource that we give a unique name to - **rg**. This is followed by mandatory parameters expected by the type of the resource and any additional optional ones available for this resource type.

## Service Plan

Every **Web App** must be connected to an **Service Plan**. This configures the type of machine we want to run our App Service on in terms of resources, and based on that is the cost that will be attached to the resource.

A Service Plan requires a unique **Name** within the Subscription, a related **Resource Group** where to reside and a **Location**. It is a good practice to keep all resources in the same location as the Resource Group itself.

The mandatory parameters that need to be set, are the **os_type** of the machine we want to use, in this case a Windows machine, and a **sku_name** that will configure the resource performance like CPU, Memory, Disk Space and more. The different skus can be found on Azure Documentation and Pricing.

```terraform
# Provision a Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "MyAppSrvPlan"
  location            = "North Europe"
  resource_group_name = "MyRG"
  os_type             = "Windows"
  sku_name            = "B1"
}
```

***Note that the resource group name used for the service plan is the same name we created earlier in the resource group code.***

There are more optional parameters that can be set. For additional information, view: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan>

## Web App

A Web App is the managed version of a web server.

```terraform
# Provision a Windows Web App to host our code
resource "azurerm_windows_web_app" "webapp" {
  name                = "MyAppSrv"
  location            = "North Europe"
  resource_group_name = "MyRG"
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}
```

For additional information, view: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service>

This is the first time we see one of Terraforms' internal mechanics called **Interpolation**. This controls the flow of execution for resources that have a dependency on other resources. When a resource is created in Azure it is given a unique ID. The ID for the newly created Service Plan needs to be supplied to the Web App resource to make that connection. In some cases the ID property and the Name property are interchangeable.

The interpolation syntax we see consists of the Resource name - **azurerm_service_plan**, the instance we declared - **plan** and the unique ID that is created - **id**.

```terraform
  service_plan_id = azurerm_service_plan.plan.id
```

Interpolation is the main reason you can declare resources anywhere in the script even if not in the order of creation. The Provider is where the brains is in terms of the order of execution to create and destroy resources.

When Terraform is executed, it scans all the files and then creates a resource graph based on the providers, interpolations and usage of **depends_on** to decide how to run the requests in the right order and also to remove the resources if needed. For additional information, view: <https://www.terraform.io/internals/graph>

As mentioned, a Web App needs to be connected to a Service Plan. This implies that the Service Plan needs to be created beforehand. But even if we see in the code that the Web App appears before the Service Plan, when the script is executed, they will be created or destroyed in the right order.

In main.1.tf we see the proper way to use interpolation instead of hardcoding values. This allows us to have a central place to make configuration changes without having to crawl over multiple files and make the changes in each of them.

```terraform
# Provision a Service Plan to host the Web App
resource "azurerm_service_plan" "plan" {
  name                = "MyAppSrvPlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}

# Provision a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "MyRG"
  location = "North Europe"
}
```

We can see that instead of the original values for location and resource_group_name, we are using the interpolated version - resource name - **azurerm_resource_group**, then the instance name - **rg** and the property names -**name** and **location**.
