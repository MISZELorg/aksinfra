variable "workspace_name" {
  description = "Base name for the Log Analytics Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the Log Analytics Workspace"
  type        = string
}

variable "location" {
  description = "Location of the Log Analytics Workspace"
  type        = string
}

variable "sku" {
  description = "SKU for the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention period for logs in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
