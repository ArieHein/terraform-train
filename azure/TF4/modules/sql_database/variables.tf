# General Variables
variable "db_resource_group" {
  description = "The SQL Database Resource Group"
  type        = string
}

variable "db_location" {
  description = "The The SQL Database Location"
  type        = string
}

# SQL Database Variables
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
  description = "The The SQL Database Tags"
  type        = map(string)
}