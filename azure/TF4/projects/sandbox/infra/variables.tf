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
