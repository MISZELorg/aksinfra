output "dns_zone_id" {
  description = "ID of the DNS private zone"
  value       = azurerm_private_dns_zone.dns_zone.id
}

output "dns_zone_name" {
  description = "ID of the DNS private zone"
  value       = azurerm_private_dns_zone.dns_zone.name
}

output "vnet_link_id" {
  description = "ID of the VNet link to the DNS zone"
  value       = azurerm_private_dns_zone_virtual_network_link.vnet_link.id
}
