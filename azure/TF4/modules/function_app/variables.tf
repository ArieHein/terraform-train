# General Variables
variable "func_resource_group" {
  description = "The Function App Resource Group"
  type        = string
}

variable "func_location" {
  description = "The Function App Location"
  type        = string
}

# Function App Variables
variable "func_name" {
  description = "The Function App Name"
  type        = string
}

variable "func_plan_id" {
  description = "The Function App Plan ID"
  type        = string
}

variable "func_sta_name" {
  description = "The Function App Storage Account Name"
  type        = string
}

variable "func_sta_access_key" {
  description = "The Function App Storage Account Access Key"
  type        = string 
}

variable "func_os_type" {
  description = "The Function App OS Type"
  type        = string
}

variable "func_tags" {
  description = "The Function App Tags"
  type        = map(string)
}