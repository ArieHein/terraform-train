# Resource Group
variable "rg_name" {
  description = "The Resource Group Name"
  type        = string
}

variable "rg_location" {
  description = "The Location of the Resource Group"
  type        = string
}

variable "rg_tags" {
  description = "The Resource Group Tags"
  type        = map(string)
}

variable "proj_loc_pre" {
  description = "Project location prefix"
}

# Subscription Variables
variable "sub_prefix" {
  description = "Subscription Prefix"
  type        = string
  default     = "rnd"
}