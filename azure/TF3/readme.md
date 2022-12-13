# TF3

## Overview

This chapter creates a more complex environment that consists of:

- Key Vault
- Key Vault Secrets
- Web App
- Service Plan
- Application Insight
- SQL Server
- SQL Database
- SQL Firewall Rule

## General

At the top of the script, under the **required_providers**, we call for the **Random** provider created by HashiCorp at the latest version available when writing. This provider is a string/value generator that allows adding some randomness to achieve overall uniqueness. We can use it in resource naming, or to generate passwords that are based on a cryptographic engine.

```terraform
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }
```

Next, we see for the first time the usage of the **Backend** block. This tells Terraform that instead of creating a state file locally, it should save it in a specific Blob Container - **container_name**, in a specific Storage Account - **storage_account_name**, in a specific Resource Group - **resource_group_name** and under a specific file name - **key**.

```terraform
terraform {
  backend "azurerm" {
    // You have to use a pre-created Resource Group and Storage Account to host the state file.
    resource_group_name  = "myTFStateRG"
    storage_account_name = "myStorageAccount"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}
```

In the **readme.md** file at the root of the Azure folder, there is a section about how to create the necessary resources to host the terraform state file, via Azure CLI commands.

For more information about how to use Azure for a backend, view: <https://www.terraform.io/language/settings/backends/azurerm>

When you run the *terraform plan* command, one of the actions will be to look for the backend details, connect to the storage account and create the file, if it is not yet there. When you run *terraform plan*, *apply* or *destroy*, it will always read the script and compare the desired state from the current state and write all the information back into the state file.

When you start to work in a team, you do not want to use a local state file as it makes it harder to share as it also requires proper handling and backup. Majority of the Cloud providers will use a storage type resource, in Azure it would be Azure Storage Account, in AWS it will be a S3 Bucket etc. Hashicorp, offers its Terraform Cloud SaaS solution to store state files as well.

**Note:** The identity used to connect and authenticate to Azure, needs to have access to the Resource Group, Storage Account and related resources to be able to access the storage account and read or write content to these files.***
This is also the first time we see a usage of the **Data** keyword. Data Sources is a way for Terraform to query the Cloud Provider for resource properties. Terraform is using this ability internally when you run the terraform commands to understand the current state.

For more information about Data structures, view: <https://www.terraform.io/language/data-sources>

In our example we are retrieving connection information that was used to connect and authenticate to the subscription. We will need some of the values later in the script via interpolation.

```terraform
# Current Connection Config
data "azurerm_client_config" "current" {
}
```

The next sections will include all of our Azure resource declarations. First, we start with our Resource Group but note a new concept we have not seen yet, **string concatenation**. If we look at the **name** property of the **Resource Group**, we see a call to the **resource_prefix** variable but we also see that we added a suffix to the field name **-rg**. When doing string concatenation, you need to encase it all with double quotes, the variable in squiggly bracers and adding a **$** character in front to denote that this is a variable.

```terraform
  name     = "${var.resource_prefix}-rg"
```

This will be a similar occurrence in all resource names, to create a naming convention that is consistent. Some resource types require uniqueness across the Resource Group, some across the Subscription and some across entire Azure, especially if the resource has a URL for access.

The next section is creating a **KeyVault**. This is a secure storage to hold, keys, secrets and certificates. As part of the resource creation, we also set the access policy that allows the same identity that connected and authenticated, access to reading and writing secrets.
This is also displaying the usage of data from **azurerm_client_config** to get connection information to then give the permission to access the secrets.

```terraform
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
```

For more information about KeyVault, view: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault>

In next section we are going to use the second provider - **Random** that was declared at the top of the script to create **random_string** and **random_password** resources. We are going to create a user and password to be used as the SQL Server admin, and create a second user and password to be used by the application connection string.

For more information about the Random provider and its resources, view: <https://registry.terraform.io/providers/hashicorp/random/latest/docs>

The next part will be to take the two users and passwords and save them as secrets in the keyvault.

```terraform
# Store the User and Password values as Secrets in the Key Vault
resource "azurerm_key_vault_secret" "sqladmuser" {
  name         = "sqladmuser"
  value        = random_string.sqladminuser.result
  key_vault_id = azurerm_key_vault.kv.id
}
```

In this example we use the **azurerm_key_vault_secret** resource, supply it with a secret **name**, the value that we take from the **random_string** resource and finally supplying the **keyvault id** that was created earlier. Note that this is also an example of dependency via interpolation where this resource will not be executed before the keyvault resource has actually been provisioned successfully.

The next resources created will be the **Web App**, **Service Plan** as we have seen in earlier chapters and an **Application Insights** to allow measuring application performance.

Additionally, we are provisioning a managed SQL Server, a SQL Database and a SQL Server Firewall Rule to allow different Azure resources to connect to the server.

The resource creation is very simple and follows the default documentation so I am not going to focus on it, except one specific configuration visible in the **Web App** resource. It does show a slightly more complex dependency management that Terraform does behind the scenes.

```terraform
  app_settings = {
      "SqlConnectionString" = "Server=tcp:${azurerm_sql_server.mssql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.mssqldb.name};Persist Security Info=False;User ID=${random_string.appuser.result};Password=${random_password.apppassword.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
      "InstrumentationKey"  = azurerm_application_insights.ais.id
  }
```

What you can see here, is that we are adding two application settings to the **Web App**.

The first is **SqlConnectionString**. This is a setting that tells the application code how to connect to the database. Notice how it includes the SQL server fully qualified domain name, the SQL Database name, and even the application user and password that were created earlier and saved to the keyvault.

This interpolation creates a dependency where the **Web App** resource will not be created before the SQL resources are provisioned successfully.

**Note:** Even though we created a second user for the application connection, Terraform does not create the actual user in the SQL Server, not does it associate it with any permissions. This task is done outside of SQL, most likely either manually or part of a CICD pipelines.

The second is **InstrumentationKey**. This is a setting that tells the application code how to connect from the application to the **Application Insights** resource to then be able to send metrics from the application.

This interpolation creates a dependency as well where the **Web App** will not be created before the **Application insights** resource is provisioned successfully.

**Note:** Setting the connection string and instrumentation key application settings can be done also manually or via a CICD pipeline. This is just an example of how to use Terraform to control it and not have to manage it potentially much simpler.

## Outputs

This is the first time we showcase terraform outputs. This is an ability of Terraform to expose to the command line values that are sometimes only known after a resource was created. It is a good practice, to create a **outputs.tf** file in the same directory as the main script, especially when we deal with Terraform modules, in the next chapter. When *terraform plan*, *apply* or *destroy* commands are used, any outputs will be displayed in the terminal interface.

In this chapter, we want to expose out the Instrumentation Key that is created after the **Application Insights** resource is provisioned. To do that we use the **output** keyword, followed by the name of the key we want to be displayed, and the value of the key. In this case, using interpolation, we reference the **azurerm_application_insights** resource, the **ais** instance and the **instrumentation_key** resource output.

```terraform
output "InstrumentationKey" {
  value = azurerm_application_insights.ais.instrumentation_key
}
```

## Variables

It is a good practice to create a **variables.tf** file in the same directory as the main script and inside Terraform modules. In it will be the declaration of all variables used in the script or module. As discussed in previous chapters, variable declarations, require at least a **type** and its good practice to add a **description** that will be displayed if there are no values supplied upon execution.

In here we also see for the first time, another ability of Terraform and that is variable validation. You would want to use variable validation when you do not have full control over the values that are being used or supplied by others. Sometimes we might use variable values that might break some resource rules, for example: a storage account name, cannot have spaces of underscores. To make sure we do not accidently supply values that might break the execution, we can add variable validation.

In our script, I have chosen to check the length of a variable, so that when it is being used in resource naming, it is not going to end up with a very long resource name.

```terraform
  validation {
    condition = length(var.resource_prefix) > 3 && length(var.resource_prefix) <= 7
    error_message = "The length of the Resource Prefix needs to be between 3 and 7 characters long"
  }
```

We need to use the **validation** block, and in it, supply a condition and an error message that will be displayed if the condition is false. In our condition, I choose to validate that the length of the variable is less than 3 characters long but not bigger than 7 characters long.

For more information about Variable Validation, view: <https://www.terraform.io/language/expressions/custom-conditions#input-variable-validation>

For more information about Terraform built-in functions, view: <https://www.terraform.io/language/functions>

## Input Variables

We mentioned in previous chapters, that some variables are supplied as part of the execution, either manually or via a command line parameter. In our case, I have created a file called **terraform.tfvars** and placed inside of it a few variables and their values.

```terraform
# General
resource_prefix         = "tftrain"
resource_group_location = "North Europe"

# Service Plan
plan_sku_name           = "B1"

# MSSQL Database
db_sql_sku              = "S0"
db_sql_max_size         = "4"
```

We can see in the variables.tf that all these variables have been declared and indeed do not have a default value, as they are all being read from the *.tfvars file. Part of Terraform execution is to scan for files with this extension and read them so they become the values for the variables declared. If Terraform cannot find any value, supplied or default, to a declared variable it will error out.

We can see that for the **resource_prefix** variable, we have a value that is 7 characters long. This means that the condition we supplied at the variable declaration will be true, and thus the script will continue. If we have chosen any value that was smaller than 3 or up to 7 in length, the execution will fail with an error.

For more information about how to supply variables values or files during execution, view: <https://www.terraform.io/language/values/variables#variables-on-the-command-line>

## Azure Connection

In this chapter, you will also find **tf.ps1**. This powershell script uses AZ CLI to create the initial resources needed for Terraform state file. This needs to run before you execute any Terraform scripts that use Azure as the backend for the state file.
