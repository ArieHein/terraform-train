# Resource Group
variable "sub_resource_group" {
  description = "Resource Group Name"
  type        = string
}

# Subnet
variable "sub_name" {
  description = "Subnet Name"
  type        = string
}

variable "sub_vnet_name" {
  description = "value"
  type        = string
}

variable "sub_add_prefix" {
  description = "value"
  type        = list(string)
}