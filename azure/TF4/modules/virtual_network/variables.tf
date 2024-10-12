# Resource Group
variable "vnet_resource_group" {
  description = "Resource Group Name"
  type        = string
}

variable "vnet_location" {
  description = "Resource Group Location"
  type        = string
}

variable "vnet_name" {
  description = "VNET Name"
  type        = string
}

variable "vnet_address_space" {
  description = "VNET Address Space"
  type        = list(string)
}

variable "vnet_tags" {
  description = "VNET Tags"
  type        = map(string)
}