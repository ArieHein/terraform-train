# General Variables
variable "sql_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "sql_location" {
  description = "The Project Location"
  type        = string
}

# SQL Database Variables
variable "sql_kv_id" {
  description = "The KeyVault ID"
  type        = string 
}

variable "sql_tags" {
  description = "The Resource Tags"
  type = map(string)
}