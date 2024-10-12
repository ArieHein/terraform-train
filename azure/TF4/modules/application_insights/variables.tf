# General Variables
variable "ais_resource_group" {
  description = "The Application Insights Resource Group"
  type        = string
}

variable "ais_location" {
  description = "The Application Insights Location"
  type        = string
}

# Application Insights Variables
variable "ais_name" {
  description = "The Application Insights Name"
  type        = string
}

variable "ais_type" {
  description = "The Application Insights Type"
  type        = string
}

variable "ais_sku" {
  description = "The Application Insights SKU"
  type        = string
}

variable "ais_tags" {
  description = "The Application Insights Tags"
  type        = map(string)
}