variable "region" {
  description = "AWS Region"
  type        = string
}

variable "ami" {
  description = "AWS AMI"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key Name"
  type        = string
}

variable "instance_name" {
  description = "Instance Name"
  type        = string
}