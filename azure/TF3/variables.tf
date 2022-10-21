variable "resource_prefix" {
  description = "The Prefix of all Resources"
  type        = string

  validation {
    condition     = length(var.resource_prefix) > 3 && length(var.resource_prefix) <= 7
    error_message = "The length of the Resource Prefix needs to be between 3 and 7 characters long"
  }
}

variable "resource_group_location" {
  description = "The location where all resources should be created in Azure"
  type        = string
}

variable "plan_sku_name" {
  description = "The Service Plan SKU Name"
  type        = string
}

variable "db_sql_sku" {
  description = "The SQL DB SKU Name"
  type        = string
}

variable "db_sql_max_size" {
  description = "The SQL DB Max Size"
  type        = string
}