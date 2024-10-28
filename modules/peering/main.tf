terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
      configuration_aliases = [
        azurerm.hub,
        azurerm.spoke
      ]
    }
  }
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  provider                     = azurerm.spoke
  name                         = "${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name          = var.spoke_rg_name
  virtual_network_name         = var.spoke_vnet_name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub
  name                         = "${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = var.spoke_vnet_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}
