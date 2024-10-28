# Resource Group and Virtual Network

resource "azurerm_resource_group" "spoke_rg" {
  name     = "${var.spoke_prefix}-rg"
  location = var.location
  tags     = var.spoke_tags
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "${var.spoke_prefix}-vnet"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  location            = var.location
  address_space       = var.spoke_vnet_cidr
  tags                = var.spoke_tags
  depends_on = [
    azurerm_resource_group.spoke_rg
  ]
}

# Define Subnets
resource "azurerm_subnet" "spoke_subnets" {
  for_each                          = var.subnets
  name                              = each.key
  resource_group_name               = azurerm_resource_group.spoke_rg.name
  virtual_network_name              = azurerm_virtual_network.spoke_vnet.name
  address_prefixes                  = [each.value.address_prefix]
  private_endpoint_network_policies = "Disabled"
  depends_on = [
    azurerm_virtual_network.spoke_vnet
  ]
}

# Define NSGs, skipping for specific subnets
resource "azurerm_network_security_group" "nsgs" {
  for_each            = { for k, v in var.subnets : k => v if !contains(["GatewaySubnet", "AzureFirewallSubnet", "AzureBastionSubnet", "appgwsubnet"], k) }
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  tags                = var.spoke_tags
}

# Associate NSGs with Subnets, skipping for specific subnets
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = { for k, v in var.subnets : k => v if !contains(["GatewaySubnet", "AzureFirewallSubnet", "AzureBastionSubnet", "appgwsubnet"], k) }

  subnet_id                 = azurerm_subnet.spoke_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

# # Create Route Table for Landing Zone
resource "azurerm_route_table" "route_tables" {
  for_each                      = { for k, v in var.subnets : k => v if !contains(["GatewaySubnet", "AzureFirewallSubnet", "AzureBastionSubnet", "appgwsubnet"], k) }
  name                          = "${var.spoke_prefix}-rt"
  resource_group_name           = azurerm_resource_group.spoke_rg.name
  location                      = var.location
  bgp_route_propagation_enabled = true
  tags                          = var.spoke_tags

  route {
    name                   = "route_to_firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }
}

# # Associate Route Table to AKS Subnet
resource "azurerm_subnet_route_table_association" "rt_associations" {
  for_each       = { for k, v in var.subnets : k => v if !contains(["GatewaySubnet", "AzureFirewallSubnet", "AzureBastionSubnet", "appgwsubnet"], k) }
  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.route_tables[each.key].id
}
