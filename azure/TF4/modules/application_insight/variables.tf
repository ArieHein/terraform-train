variable "ais_project_prefix" {
  description = "The Project Prefix"
  type        = string
}

variable "ais_project_location_prefix" {
  description = "The Project Location Prefix"
  type        = string
}

variable "ais_environment_prefix" {
  description = "The Environment Prefix"
  type        = string
}

variable "ais_location" {
  description = "The Project Location"
  type        = string
}

variable "ais_resource_group" {
  description = "The Resource Group"
  type        = string
}

variable "ais_tags" {
  description = "The Resource Tags"
  type        = map(string)
}