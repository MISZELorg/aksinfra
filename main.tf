module "spoke_networking" {
  source          = "./modules/spoke_networking"
  spoke_prefix    = var.spoke_prefix
  location        = var.location
  spoke_tags      = var.spoke_tags
  spoke_vnet_cidr = var.spoke_vnet_cidr
  subnets         = var.subnets
}

module "peering" {
  source = "./modules/peering"
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub   = azurerm.hub
  }
  spoke_rg_name                = module.spoke_networking.spoke_rg_name
  spoke_vnet_name              = module.spoke_networking.spoke_vnet_name
  spoke_vnet_id                = module.spoke_networking.spoke_vnet_id
  hub_rg_name                  = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_rg_name
  hub_vnet_name                = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_vnet_name
  hub_vnet_id                  = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on = [
    module.spoke_networking
  ]
}

# module "acr_dns_zone" {
#   source              = "./modules/dns_zone"
#   dns_zone_name       = "privatelink.azurecr.io"
#   resource_group_name = module.spoke_networking.spoke_rg_name
#   vnet_link_name      = "spoke_to_acrs"
#   virtual_network_id  = module.spoke_networking.spoke_vnet_id
#   depends_on = [
#     module.spoke_networking
#   ]
# }

# module "kv_dns_zone" {
#   source              = "./modules/dns_zone"
#   dns_zone_name       = "privatelink.vaultcore.azure.net"
#   resource_group_name = module.spoke_networking.spoke_rg_name
#   vnet_link_name      = "spoke_to_kvs"
#   virtual_network_id  = module.spoke_networking.spoke_vnet_id
#   depends_on = [
#     module.spoke_networking
#   ]
# }

# module "appgw_nsgs" {
#   source = "./modules/app_gw_nsg"

#   resource_group_name = module.spoke_networking.spoke_rg_name
#   location            = module.spoke_networking.spoke_rg_location
#   nsg_name            = "${module.spoke_networking.spoke_vnet_name}-appgw-nsg"
#   appgw_subnet_id     = module.spoke_networking.subnet_ids["appgwsubnet"]
#   depends_on = [
#     module.spoke_networking
#   ]
# }

# module "appgw" {
#   source = "./modules/app_gw"

#   for_each             = { for appgws in local.appgws : appgws.name_prefix => appgws if appgws.appgw_turn_on == true }
#   resource_group_name  = module.spoke_networking.spoke_rg_name
#   virtual_network_name = module.spoke_networking.spoke_vnet_name
#   location             = var.location
#   appgw_name           = "${each.value.name_prefix}-appgw"
#   frontend_subnet      = module.spoke_networking.subnet_ids["appgwsubnet"]
#   #   appgw_pip            = azurerm_public_ip.appgw[each.value.name_prefix].id
#   appgw_pip = module.pip[each.key].public_ip_id
#   depends_on = [
#     module.appgw_nsgs
#   ]
# }

# module "pip" {
#   source = "./modules/pip"

#   for_each            = { for appgws in local.appgws : appgws.name_prefix => appgws if appgws.appgw_turn_on == true }
#   pip_name            = "${each.value.name_prefix}-appgw-pip"
#   resource_group_name = module.spoke_networking.spoke_rg_name
#   location            = module.spoke_networking.spoke_rg_location
# }