variable "sql_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "sql_project_location" {
  description = "The Project Location"
  type        = string
}

variable "sql_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "sql_location" {
  description = "The Project Location"
  type        = string
}

variable "sql_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "sql_kv_id" {
  description = "The KeyVault ID"
  type        = string 
}

variable "sql_tags" {
  description = "The Resource Tags"
  type = map(string)
}