# Project Variables
variable "project_name" {
  description = "Project Name"
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) >= 5 && length(trimspace(var.project_name)) <= 20 && can(regex("[[:alpha:]]", var.project_name))
    error_message = "Project Name should consist of alpha characters only (Min 5, Max 20)."
  }
}

variable "project_prefix" {
  description = "Project Prefix. Is used for Resource naming."
  type        = string

  validation {
    condition     = length(trimspace(var.project_prefix)) >= 3 && length(trimspace(var.project_prefix)) <= 10 && can(regex("[[:alpha:]]", var.project_prefix))
    error_message = "Project Prefix should consist of alpha characters only (Min 3, Max 10)."
  }
}

variable "project_location" {
  description = "Project Location. List of allowed Regions."
  type        = string

  validation {
    condition     = contains(["northeurope"], lower(var.project_location))
    error_message = "The Project Location is not valid."
  }
}

variable "project_location_prefix" {
  description = "Project Location Prefix"
  default = {
    "northeurope" = "ne"
  }
}

# Key Vault
variable "key_vault_sku" {
  description = "The SKU of the KeyVault. Values are: Standard, Premium."
  type        = string

  validation {
    condition     = contains(["standard", "premium"], lower(trimspace(var.key_vault_sku)))
    error_message = "KeyVault SKU is not a valid. Values are: Standard, Premium."
  }
}

# Tags
variable "project_tags" {
  description = "Project Level Tags"
  type        = map(string)
  default = {
    Project = ""
  }
}

# Azure Connection variables
variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
}

# kv Service Variables
variable "kv_secret_perm" {
  description = "list of KV secrets permission"
  type        = list(string)
  default     = [
    "get",
    "set",
    "list",
    "delete",
    "purge",
  ]
}

variable "kv_key_perm" {
  description = "list of kv key permission"
  type        = list(string)
  default     = [
    "create",
    "list",
    "get",
  ]
}

variable "kv_cert_perm" {
  description = "list of kv certificate permission"
  type        = list(string)
  default     = [
    "get",
    "list",
    "update",
  ]
}