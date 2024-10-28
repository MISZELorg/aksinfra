variable "dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the DNS zone will be created"
  type        = string
}

variable "vnet_link_name" {
  description = "Name of the VNet link to the DNS zone"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the virtual network to link to the DNS zone"
  type        = string
}
