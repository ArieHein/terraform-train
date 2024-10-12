# General Variables
variable "kv_resource_group" {
  description = "The KeyVault Resource Group"
  type        = string
}

variable "kv_location" {
  description = "The KeyVault Location"
  type        = string
}

# Key Vault Variables
variable "kv_name" {
  description = "The Keyvault Name"
  type        = string
}

variable "kv_tenant_id" {
  description = "The KeyVault Tenant ID"
  type        = string
}

variable "kv_object_id" {
  description = "The KeyVault Object ID"
  type        = string
}

variable "kv_sku_name" {
  description = "The KeyVault SKU Name. Values are: Standard, Premium"
  type        = string
  default     = "Standard"
}

variable "kv_tags" {
  description = "The KeyVault Tags"
  type        = map(string)
}