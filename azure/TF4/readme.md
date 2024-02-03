# TF4

***Note: If you try to run terraform in this folder, it will error out as terraform will try to run both *.tf files. Rename one of the files or remove it to avoid errors***

## Overview

This is a more complex and modular project structure.
We see for the first time the usage of modules and environment separation.
Good for teams of any size / small-medium organizations.
Good for all environments, medium to large scale.
We start seeing some separation of concerns, quite easy to manage changes.
Early design for Organization scope.

## General

This chapter is split into two parts. Part one will discuss the concept of Terraform **Modules**, and the second will discuss a logical layer of abstraction that I refer to as **Components** or **Stacks**. This is not a Terraform concept but as the power of modules becomes more understandable, we will try and scale it up to organization levels together with the following chapter.

The most immediate visible change is that all parts of a terraform script have now been split into their own files, thus separating content that is unlikely to ever change and content that changes more frequently. Since Terraform scans all files in the folder upon execution, we can have as many terraform files as we want, in whatever directory structure, allowing us to design our folder structure and implement some **separation of concerns** where different teams are responsible for different resources or modules.

In the root of the project, we see a file called **project.tfvars**. This file holds global variable values that we want to use throughout the execution of the terraform script, no matter for what environment. In it we find variables like the **Project Name** that we will use in tags, **Project Location** that we will use to create the resources so they are all in the same region, and some prefixes that will allow us to create resource names that are more unique.

In main.0.tf file, is where we also see for the first time the usage of **Locals**. These are variables that are scoped to the specific terraform file. We can see one usage of this, where I create two variables to hold tags that we will use later. It is a good practice to have some tags for each Resource Group / Resource to allow better visibility in terms of cost.

```terraform
locals {
  resource_group_tags = {
    Project = var.project_name
  }
  resource_tags = {
    Environment = var.environment_name
    CreatedBy   = "Terraform"
  }
}
```

We can see that the values of these tags are also environment dependent.

This is where we see another aspect of IaC and that is the ability to create the same infrastructure constructs for all of our environments. Yes, some configuration of resources might be different in terms of capacity or SKU but the more we trust that our environments are an exact copy, it becomes much easier to debug or have behavior expectations of the code as its being deployed to different environments.

For this purpose, we have a folder called **environments**, in it you would find a *.tfvar file for each environment, in our example we have a Development, QA and Production environments. You can see that all files have the exact same structure with same keys, but sometimes different values and this is exactly what we want. We want to have the same exact resources, but still have the ability to choose bigger / stronger resources for production but simpler ones in non-production that will cost less.

```terraform
# Environment
environment_name   = "Development"
environment_prefix = "dev"

# Service Plan
plan_sku_name     = "B1"
plan_worker_count = 1

# MSSQL Database
db_sql_sku      = "S0"
db_sql_max_size = "4"
```

As we have seen in past chapters, all variables used need to be declared and thus we can see all these variables are declared in **variables.tf** at the root of the project.

Back to our main file, we see in the Resource Group provisioning, that this time we are using the environment prefix in the resource naming, and we are also adding the location prefix to, adding to the overall uniqueness of the resource name.

```terraform
name     = "${var.project_prefix}-${var.project_location_prefix}-${var.environment_prefix}-rg"
```

For the dev environment, terraform will evaluate this to be:

```terraform
tftrain-eun-dev-rg
```

And last, we see a usage of one of Terraform's built-in string functions called **Merge** which takes the 2 values and adds them together to one object, which we are using for the **Tags**. We can see that we are referring to both local variables and then merging the values into one object used for the Resource Group tags.

```terraform
tags     = merge(local.resource_group_tags, local.resource_tags)
```

And this now, is the main start of this chapter - **Terraform Modules**. These are the equivalent of functions / templates / libraries in other programming languages. It allows us to create an infrastructure construct that then can be called multiple times, with the ability to sometimes change some of its configurations. It creates a consistent way of creating resources and promotes the idea of Don’t-Repeat-Yourself (DRY).

We can see that a module is first declared by using the **Module** keyword. In the Module block, we have variables that are then assigned a specific value. These are the equivalents of function's parameters, that are then used inside the module. Remember that interpolation creates a dependency that will be forced upon execution.

The most important part of a module declaration is the **source** property. This tells Terraform where to get the module definition from. In our case we point it to specific relative folder path. Terraform Modules also support additional types of sources.

```terraform
module "key_vault" {
  source                = "../modules/key_vault"
```

Note that in the root of the chapter, we have created a **Modules** folder and inside of it many types of Module folders based on the resource we want to create. In each we can see the typical files - **main.tf** which will be main script to create the resource, **outputs** to return some module outputs if needed and **variable** where we declare all the variables used inside the module.

If we do go to the modules folder and look for the key_vault module for example, we see in its main.tf basically the same resource provisioning script we have seen before. The difference is that the majority of the properties are now passed as variables from the calling script.

```terraform
# Provision a KeyVault
resource "azurerm_key_vault" "kv" {
  name                     = "${var.kv_project_prefix}-${var.kv_project_location_prefix}-${var.kv_environment_prefix}-kv"
  location                 = var.kv_location
  resource_group_name      = var.kv_resource_group
  tenant_id                = var.kv_tenant_id
```

***Note:*** In the main.tf of a module folder, at the top you need to declare the version of terraform required for the module.

```terraform
terraform {
  required_version = "=1.3.3"
}
```

As mentioned above, interpolation can also create a dependency to modules as well. An example can be seen in the Web App module

```terraform
module "web_app" {
  source                  = "../modules/web_app"
  ...
  ...
  app_instrumentation_key = module.application_insights.instrumentation_key
  app_plan_id             = module.service_plan.plan_id
  app_sql_server_name     = module.sql_server.server_name
  app_sql_database_name   = module.sql_database.sql_database_name
  app_kv_id               = module.key_vault.kv_id

```

This means that the web app module, will only get provisioned after each of the other modules it depends on, returns an answer. In each module, under the **outputs.tf** we can see the values that are sent to the calling script to continue the execution of the **web app** resource. An example for the **Application Insight** would be:

```terraform
output "instrumentation_key" {
  value = azurerm_application_insights.ias.instrumentation_key
}
```

If we look at the SQL Server module for example, we can see that we also placed there the creation of the user and password and the uploading this to keyvault. The main reason behind this is that each SQL server requires a user and password values when provisioning it, thus it makes sense that creating a server will also create a user and password, as all are considered in the state file as one unit. Thus, it makes sense to add the creation of the resource and the user and password in the same module.

```terraform
resource "azurerm_sql_server" "mssql" {
  name                         = "${var.sql_project_prefix}-${var.sql_project_location}-${var.sql_environment_prefix}-sql"
  location                     = var.sql_location
  resource_group_name          = var.sql_resource_group
  version                      = "12.0"
  administrator_login          = random_string.sqladminuser.result
  administrator_login_password = random_password.sqladminpassword.result
  tags                         = var.sql_tags
}
```

As we have seen in previous chapters, we can execute Terraform, and pass it variables and variable files on the command line, and that is exactly how we will manage the environments. The command line will look something like this:

```powershell
terraform plan --var-file ..\environments\dev.tfvars
```

Thus, allowing us to use a different environment file on each execution. This is why it is so important that the structure of the environment files is consistent.

## Summary

We added support to environments, we have split the resources to modules and we have seen how to use local scoped variables and how to use the output of scripts as input for other modules.

It is essential that you familiarize yourselves with Terraform Modules and how it simplifies reusability and more organized way to write terraform scripts, especially at scale. To read a great deal more about modules, view: <https://developer.hashicorp.com/terraform/language/modules>

One aspect that is slightly more advanced is stacks / components. As mentioned at the start, these are not Terraform concepts, rather a potential layer of abstraction we can create on top of what we learned earlier.

Let us continue to main.1.tf. We can see immediately that it is shorter and slightly easier to understand.
We can see that instead of calling the specific modules we created, we call a component / stack that is located in the **components** folder. It is then calling the different resources that make the component.

```terraform
module "app" {
  source                       = "../components/app"
```

And if we look at the **app** component, we see it is calling all the modules that make an app - the **web app**, the **service plan** and the **application insights**

If we look at the **db** component, we can see it is calling all the module that make a db - the **sql server**, the **sql database**, and the **sql firewall rule**

In the folder structure, we created a folder called **components** and inside we have a component called **app** and one called **db**. If you look inside them it will seem like a normal module, but here is where its slightly different. Notice that the main script in the app component actually calls all 3 modules, thus saving some variables changing hands. Remember that Terraform works both for creation and removal.

This means we can create multiple components / stacks of predefined scripts allowing the users to just pick the ones that match their project and only supply the value of the variables in a bigger structure. This can be even scaled to an organization component to allow governance and best practices, and a level of control where a central team creates all the components, and the developers just point to the component and supply the necessary values.

In the next chapter, we will take this idea even one level higher and talk about implications at organization / enterprise level.
