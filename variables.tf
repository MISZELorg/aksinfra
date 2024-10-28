variable "location" {
  description = "Azure region for the resources."
  type        = string
}

variable "subnets" {
  description = "Map of subnets with their names and address prefixes"
  type = map(object({
    address_prefix = string
  }))
}

variable "spoke_tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
}

variable "spoke_prefix" {
  description = "Prefix for the spoke resources."
  type        = string
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the spoke VNET."
  type        = list(string)
}

variable "hub_state_sub_id" {
  description = "Hub VNET subscription ID"
  type        = string
}

variable "hub_state_rg_name" {
  description = "Hub VNET resource group name."
  type        = string
}

variable "hub_state_sa_name" {
  description = "Hub VNET statefile storage account name."
  type        = string
}

variable "hub_state_container_name" {
  description = "Hub VNET statefile container name."
  type        = string
}

variable "hub_state_key" {
  description = "Hub VNET statefile name."
  type        = string
}

variable "hub_subscription_id" {
  description = "Hub VNET subscription ID."
  type        = string
}