# Service Plan Module

## Overview

This module creates one instance of Service Plan resource in Azure.

## Input Parameters

This module expects the following parameters:

| Parameter | Description |
|---|---|
| plan_resource_group | The Name of the Resource Group |
| plan_location | The Location of the Service Plan |
| plan_name | The Name of the Service Plan |
| plan_os_type | The OSType of the Service Plan |
| plan_sku_name | The SKU of the Service Plan |
| plan_worker_count | The Worker Count of the Service Plan. Default is 1 |
| plan_tags | The Tags to add to the resource |

## Output Parameters

This module exposes the following outputs:

| Parameter | Description |
|---|---|
| plan_id | This is the id of the Service Plan |

## Additional information

Additional information can be found at [Terraform Registry - AzureRM Provider - Service Plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights)
