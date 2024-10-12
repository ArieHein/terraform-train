# General Variables
variable "sta_resource_group" {
  description = "The Storage Account Resource Group"
  type        = string
}

variable "sta_location" {
  description = "The Storage Account Location"
  type        = string
}

# Storage Account Variables
variable "sta_name" {
  description = "The Storage Account Name"
  type        = string
}

variable "sta_tier" {
  description = "The Storage Account Tier"
  type        = string
}

variable "sta_kind" {
  description = "The Storage Account Kind"
  type        = string
}

variable "sta_replication_type" {
  description = "The Storage Account Replication Type"
  type        = string
}

variable "sta_min_tls" {
  description = "The Storage Account minimum supported TLS version"
  type        = string
}

variable "sta_tags" {
  description = "Storage Account Resource Tags"
  type        = map(string)
}

variable "sta_containers" {
  description = "The Names of the Storage Account Containers to create"
  type        = list(string)
}

variable "sta_container_access" {
  description = "Access level of a single container"
  type        = string
}