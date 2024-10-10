variable "app_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "app_project_location" {
  description = "The Project Location"
  type        = string
}

variable "app_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "app_location" {
  description = "The Project Location"
  type        = string
}

variable "app_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "app_plan_id" {
  description = "The Service Plan ID"
  type        = string
}

variable "app_sql_server_name" {
  description = "The SQL Server Name"
  type        = string
}

variable "app_sql_database_name" {
  description = "The SQL Database Name"
  type        = string
}

variable "app_instrumentation_key" {
  description = "The Instrumentation Key"
  type        = string
}

variable "app_kv_id" {
  description = "The KeyVault ID"
  type        = string
}

variable "app_tags" {
  description = "The Resource Tags"
  type        = map(string)
}