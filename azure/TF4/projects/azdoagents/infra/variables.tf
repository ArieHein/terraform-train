# Subscription Variables
variable "sub_prefix" {
  description = "Subscription Prefix"
  type        = string
  default     = "rnd"
}

# Project Variables
variable "project_name" {
  description = "Project Name"
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) >= 5 && length(trimspace(var.project_name)) <= 20 && can(regex("[[:alpha:]]", var.project_name))
    error_message = "Project Name should consist of alpha characters only (Min 5, Max 20)."
  }  
}

variable "project_prefix" {
  description = "Project Prefix. Is used for Resource naming."
  type        = string

  validation {
    condition     = length(trimspace(var.project_prefix)) >= 3 && length(trimspace(var.project_prefix)) <= 10 && can(regex("[[:alpha:]]", var.project_name))
    error_message = "Project Prefix should consist of alpha characters only (Min 3, Max 10)"
  }
}

variable "project_location" {
  description = "Project Location. List of allowed Regions."
  type        = string

  validation {
    condition     = contains(["northeurope"], lower(var.location))
    error_message = "The Project Location is not valid."
  }
}

# Windows Virtual Machine
variable "win_sku" {
  description = "The SKU of Windows Virtual Machines"
  type        = string
}

variable "win_instances" {
  description = "The number of Windows Virtual Machines"
  type        = string
}

variable "win_min_instances" {
  description = "The minimum number of Windows Virtual Machines"
  type        = string
}

# Linux Virtual Machine
variable "lin_sku" {
  description = "The SKU of Linux Virtual Machines"
  type        = string
}

variable "lin_instances" {
  description = "The number of Linux Virtual Machines"
  type        = string
}

variable "lin_min_instances" {
  description = "The minimum number of Linux Virtual Machines"
  type        = string
}

variable "vm_admin" {
  description = "The Virtual Machine Admin User"
  type        = string
}

variable "vm_admin_pwd" {
  description = "The Virtual Machine Admin User Password"
  type        = string
}