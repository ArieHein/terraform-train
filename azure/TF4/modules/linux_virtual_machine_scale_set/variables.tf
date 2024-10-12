# Resource Group
variable "vmss_resource_group" {
  description = "Resource Group Name"
  type        = string
}

variable "vmss_location" {
  description = "Resource Group Location"
  type        = string
}

variable "vmss_name" {
  description = "value"
  type = string
}

variable "vmss_sku" {
  description = "value"
  type = string
}

variable "vmss_count" {
  description = "value"
  type = string
}

variable "vmss_aduser" {
  description = "value"
  type = string
}

variable "vmss_adpwd" {
  description = "value"
  type = string
}

variable "vmss_publisher" {
  description = "value"
  type = string
}

variable "vmss_offer" {
  description = "value"
  type = string
}

variable "vmss_sku" {
  description = "value"
  type = string
}

variable "vmss_version" {
  description = "value"
  type = string
}

variable "vmss_sta_type" {
  description = "value"
  type = string
}

variable "vmss_caching" {
  description = "value"
  type = string
}

variable "vmss_nic_name" {
  description = "value"
  type = string
}

variable "vmss_nic_primary" {
  description = "value"
  type = string
}

variable "vmss_ipconfig_name" {
  description = "value"
  type = string
}

variable "vmss_ipconfig_primary" {
  description = "value"
  type = string
}

variable "vmss_subnet_id" {
  description = "value"
  type = string
}

variable "vmss_tags" {
  description = "value"
  type = map(string)
}