variable "plan_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "plan_project_location_prefix" {
  description = "The Project Location Prefix"
  type        = string
}

variable "plan_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "plan_location" {
  description = "The Project Location"
  type        = string
}

variable "plan_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "plan_os_type" {
  description = "The Service Plan OS Name"
  type        = string
}

variable "plan_sku_name" {
  description = "The Service Plan SKU Name"
  type        = string
}

variable "plan_worker_count" {
  description = "Service Plan Worker Count"
  type        = number
}

variable "plan_tags" {
  description = "The Resource Tags"
  type        = map(string)
}