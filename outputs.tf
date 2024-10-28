# # the app gateway name for each instance provisioned. If you are not using the blue green deployment then you can remove the for loop and use directly the attributes of the module module.appgw.
# output "gateway_name" {
#   value = { for appgws in module.appgw : appgws.gateway_name => appgws.gateway_name }
# }

# # the app gateway id for each instance provisioned. If you are not using the blue green deployment then you can remove the for loop and use directly the attributes of the module module.appgw.
# output "gateway_id" {
#   value = { for appgws in module.appgw : appgws.gateway_name => appgws.gateway_id }
# }

# # PIP IDs to permit the A Records registration in the DNS zone to invke the apps deployed on AKS. There is a PIP for each instance provisioned. If you are not using the blue green deployment then you can remove the for loop and use directly the attributes of the azurerm_public_ip.appgw resource.
# output "azurerm_public_ip_ref" {
#   value = { for pips in azurerm_public_ip.appgw : pips.name => pips.id }
# }

# output "appgw_subnet_id" {
#   value = azurerm_subnet.appgw.id
# }

# output "appgw_subnet_name" {
#   value = azurerm_subnet.appgw.name
# }

# output "acr_private_zone_id" {
#   value = azurerm_private_dns_zone.acr-dns.id
# }

# output "acr_private_zone_name" {
#   value = azurerm_private_dns_zone.acr-dns.name
# }

# output "kv_private_zone_id" {
#   value = azurerm_private_dns_zone.kv-dns.id
# }

# output "kv_private_zone_name" {
#   value = azurerm_private_dns_zone.kv-dns.name
# }