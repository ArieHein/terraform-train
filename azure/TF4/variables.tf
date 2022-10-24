# Project Variables
variable "project_name" {
  description = "The Project Name"
  type        = string
}

variable "project_location" {
  description = "The Project Location"
  type        = string
}

variable "project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "project_location_prefix" {
  description = "The Project Location Prefix"
  type        = string
}

# Environment Variables
variable "environment_name" {
  description = "The Environment Name"
  type        = string
}

variable "environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

# Service Plan
variable "plan_sku_name" {
  description = "The Service Plan SKU Name"
  type        = string
}

variable "plan_worker_count" {
  description = "Service Plan Worker Count"
  type        = number
}

# SQL Server and Database
variable "db_sql_sku" {
  description = "The SQL DBDatabase SKU Name"
  type        = string
}

variable "db_sql_max_size" {
  description = "The SQL Database Max Size"
  type        = string
}