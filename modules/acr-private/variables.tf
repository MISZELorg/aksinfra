variable "acrname" {}

variable "resource_group_name" {}

variable "location" {}

variable "aks_sub_id" {}

variable "private_zone_id" {}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}