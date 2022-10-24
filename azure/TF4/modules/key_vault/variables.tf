variable "kv_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "kv_project_location_prefix" {
  description = "The Project Location Prefix"
  type        = string
}

variable "kv_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "kv_location" {
  description = "The Project Location"
  type        = string
}

variable "kv_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "kv_tenant_id" {
  description = "The Tenant ID"
  type = string
}

variable "kv_object_id" {
  description = "The Object ID"
  type        = string
}

variable "kv_tags" {
  description = "The Resource Tags"
  type        = map(string)
}