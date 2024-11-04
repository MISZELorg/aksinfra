variable "uami_name" {
  description = "Name of the User Assigned Managed Identity"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the User Assigned Managed Identity"
  type        = string
}

variable "location" {
  description = "The Azure region where the User Assigned Managed Identity should be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
