variable "location" {}

variable "resource_group_name" {}

variable "name" {}

variable "vnet_id" {}

variable "zone_resource_group_name" {}

variable "dest_sub_id" {}

variable "private_zone_id" {}

variable "private_zone_name" {}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}







