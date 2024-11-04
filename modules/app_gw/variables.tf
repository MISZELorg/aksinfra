variable "appgw_name" {}

variable "resource_group_name" {}

variable "location" {}

variable "frontend_subnet" {}

variable "virtual_network_name" {}

variable "appgw_pip" {}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}