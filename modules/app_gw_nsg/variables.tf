variable "location" {}

variable "resource_group_name" {}

variable "nsg_name" {}

variable "appgw_subnet_id" {}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}