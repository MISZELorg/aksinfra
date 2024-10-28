output "spoke_rg_location" {
  description = "Spoke RG location"
  value       = azurerm_resource_group.spoke_rg.location
}

output "spoke_rg_name" {
  description = "Spoke RG name"
  value       = azurerm_resource_group.spoke_rg.name
}

output "spoke_vnet_name" {
  description = "Spoke Vnet name"
  value       = azurerm_virtual_network.spoke_vnet.name
}

output "spoke_vnet_id" {
  description = "Spoke Vnet ID"
  value       = azurerm_virtual_network.spoke_vnet.id
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = { for k, v in azurerm_subnet.spoke_subnets : k => v.id }
}

output "nsg_ids" {
  description = "Map of NSG IDs"
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

output "rt_ids" {
  description = "Map of RT IDs"
  value       = { for k, v in azurerm_route_table.route_tables : k => v.id }
}