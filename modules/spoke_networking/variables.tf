variable "subnets" {
  description = "Map of subnets with their names and address prefixes"
  type = map(object({
    address_prefix = string
  }))
}

variable "spoke_prefix" {
  description = "Prefix for the spoke resources."
  type        = string
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
}

variable "spoke_tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the spoke VNET."
  type        = list(string)
}