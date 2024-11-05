# module "spoke_networking" {
#   source = "./modules/spoke_networking"

#   spoke_prefix    = var.spoke_prefix
#   location        = var.location
#   spoke_vnet_cidr = var.spoke_vnet_cidr
#   subnets         = var.subnets
#   tags            = var.spoke_tags
# }

# module "peering" {
#   source = "./modules/peering"
#   providers = {
#     azurerm.spoke = azurerm.spoke
#     azurerm.hub   = azurerm.hub
#   }

#   spoke_rg_name                = module.spoke_networking.spoke_rg_name
#   spoke_vnet_name              = module.spoke_networking.spoke_vnet_name
#   spoke_vnet_id                = module.spoke_networking.spoke_vnet_id
#   hub_rg_name                  = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_rg_name
#   hub_vnet_name                = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_vnet_name
#   hub_vnet_id                  = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_vnet_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
#   depends_on = [
#     module.spoke_networking
#   ]
# }