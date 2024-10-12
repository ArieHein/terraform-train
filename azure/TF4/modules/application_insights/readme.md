# Application Insights Module

## Overview

This module creates one instance of Application Insights resource in Azure.
This is a Workspace mode of Application Insights, using log analytics wworkspace.

## Input Parameters

This module expects the following parameters for Application Inisghts:

| Parameter | Description |
|-|-|
| rg_name | The Name of the Resource Group. |
| rg_location | The Location of the Resource Group. |
| appi_name | The Name of the Application Insigts resource. |
| appi_type | The Type of the Application Insights. Default value: web. |
| appi_tags | The Tags to add to the resource. |

This module expects the following parameters for Log Analytics Workspace:

| Parameter | Description |
|-|-|
| rg_name | The Name of the Resource Group. |
| rg_location | The Location of the Resource Group. |
| law_name | The Name of the Log Analytics Workspace. |
| law_sku | The SKU of the Log Analytics Workspace. Default value: PerGB2018. |
| law_retention | The Retention in Days for Log Analytics Workspace. |
| law_tags | The Tags to add to the resource. |

## Output Parameters

This module exposes the following outputs:

| Parameter | Description |
|-|-|
| instrumentation_key | This is the instrumentation key required by other services when they connect to Application Insights. |

## Additional information

Additional information can be found at [Terraform Registry - AzureRM Provider - Application Insights Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights)
