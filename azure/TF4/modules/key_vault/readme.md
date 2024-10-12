# KeyVault Module

## Overview

This module creates one instance of KeyVault resource in Azure.

## Input Parameters

This module expects the following parameters:

| Parameter | Description |
|---|---|
| kv_resource_group | The Name of the Resource Group |
| kv_location | The Location of the KeyVault |
| kv_name | The Name of the KeyVault |
| kv_sku_name | The SKU of the KeyVault |
| kv_tags | The Tags to add to the KeyVault |

## Output Parameters

This module exposes the following outputs:

| Parameter | Description |
|---|---|
| kv_id | This is the id of the KeyVault |

## Additional information

Additional information can be found at [Terraform Registry - AzureRM Provider - KeyVault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)
