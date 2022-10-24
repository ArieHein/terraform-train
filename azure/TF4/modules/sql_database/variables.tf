variable "db_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "db_project_location_prefix" {
  description = "The Project Location Prefix"
  type        = string
}

variable "db_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "db_location" {
  description = "The Project Location"
  type        = string
}

variable "db_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "db_sql_server_id" {
  description = "The SQL Server ID"
  type        = string
}

variable "db_max_size" {
  description = "The SQL Database Max Size"
  type        = string
}

variable "db_sku_name" {
  description = "The SQL Database SKU Name"
  type        = string
}

variable "db_tags" {
  description = "The Resource Tags"
  type        = map(string)
}