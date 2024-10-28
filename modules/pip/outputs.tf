output "public_ip_id" {
  description = "The ID of the public IP"
  value       = azurerm_public_ip.pip.id
}

output "public_ip_address" {
  description = "The assigned public IP address"
  value       = azurerm_public_ip.pip.ip_address
}

output "public_ip_fqdn" {
  description = "The Fully Qualified Domain Name of the Public IP"
  value       = azurerm_public_ip.pip.fqdn
}