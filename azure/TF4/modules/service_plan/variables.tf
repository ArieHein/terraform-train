# General Variables
variable "plan_resource_group" {
  description = "The Service Plan Resource Group"
  type        = string
}

variable "plan_location" {
  description = "The Service Plan Location"
  type        = string
}

# Service Plan Variables
variable "plan_name" {
  description = "The Service Plan Name"
  type        = string
}

variable "plan_os_type" {
  description = "The Service Plan OS Type"
  type        = string
}

variable "plan_sku_name" {
  description = "The Service Plan SKU Name"
  type        = string
}

variable "plan_worker_count" {
  description = "The Service Plan Worker Count"
  type        = number
  default     = 1
}

variable "plan_tags" {
  description = "The Service Plan Tags"
  type        = map(string)
}