# variables.tf in modules/vnet_peering

variable "spoke_rg_name" {
  description = "The name of the resource group for the spoke VNet."
  type        = string
}

variable "spoke_vnet_name" {
  description = "The name of the spoke virtual network."
  type        = string
}

variable "spoke_vnet_id" {
  description = "The ID of the spoke virtual network."
  type        = string
}

variable "hub_rg_name" {
  description = "The name of the resource group for the hub VNet."
  type        = string
}

variable "hub_vnet_name" {
  description = "The name of the hub virtual network."
  type        = string
}

variable "hub_vnet_id" {
  description = "The ID of the hub virtual network."
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Allow access between virtual networks."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic between virtual networks."
  type        = bool
  default     = true
}

variable "allow_gateway_transit" {
  description = "Allow gateway transit between virtual networks."
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Use remote gateways for peering."
  type        = bool
  default     = false
}