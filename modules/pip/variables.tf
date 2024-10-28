variable "pip_name" {
  description = "The name of the public IP."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the public IP."
  type        = string
}

variable "location" {
  description = "The Azure location for the public IP."
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for the IP address. Options are Static or Dynamic."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP. Options are Basic or Standard."
  type        = string
  default     = "Standard"
}

