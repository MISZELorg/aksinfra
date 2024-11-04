module "spoke_networking" {
  source = "./modules/spoke_networking"

  spoke_prefix    = var.spoke_prefix
  location        = var.location
  spoke_vnet_cidr = var.spoke_vnet_cidr
  subnets         = var.subnets
  tags            = var.spoke_tags
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

module "acr_dns_zone" {
  source = "./modules/dns_zone"

  dns_zone_name       = "privatelink.azurecr.io"
  resource_group_name = module.spoke_networking.spoke_rg_name
  vnet_link_name      = "spoke_to_acrs"
  virtual_network_id  = module.spoke_networking.spoke_vnet_id
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "kv_dns_zone" {
  source = "./modules/dns_zone"

  dns_zone_name       = "privatelink.vaultcore.azure.net"
  resource_group_name = module.spoke_networking.spoke_rg_name
  vnet_link_name      = "spoke_to_kvs"
  virtual_network_id  = module.spoke_networking.spoke_vnet_id
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "acr" {
  source = "./modules/acr-private"

  acrname             = "${var.aks_appname}acr"
  resource_group_name = module.spoke_networking.spoke_rg_name
  location            = module.spoke_networking.spoke_rg_location
  aks_sub_id          = module.spoke_networking.subnet_ids["akssubnet"]
  private_zone_id     = module.acr_dns_zone.dns_zone_id
  tags                = var.spoke_tags
  depends_on = [
    module.acr_dns_zone,
    module.spoke_networking
  ]
}

module "kv" {
  source = "./modules/kv-private"

  name                     = "${var.aks_appname}kv"
  resource_group_name      = module.spoke_networking.spoke_rg_name
  location                 = module.spoke_networking.spoke_rg_location
  vnet_id                  = module.spoke_networking.spoke_vnet_id
  dest_sub_id              = module.spoke_networking.subnet_ids["akssubnet"]
  private_zone_id          = module.kv_dns_zone.dns_zone_id
  private_zone_name        = module.kv_dns_zone.dns_zone_name
  zone_resource_group_name = module.spoke_networking.spoke_rg_name
  tags                     = var.spoke_tags
  depends_on = [
    module.kv_dns_zone,
    module.spoke_networking
  ]
}

module "appgw_nsg" {
  source = "./modules/app_gw_nsg"

  resource_group_name = module.spoke_networking.spoke_rg_name
  location            = module.spoke_networking.spoke_rg_location
  nsg_name            = "${module.spoke_networking.spoke_vnet_name}-appgw-nsg"
  appgw_subnet_id     = module.spoke_networking.subnet_ids["appgwsubnet"]
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "appgw" {
  source = "./modules/app_gw"

  for_each             = { for appgws in local.appgws : appgws.name_prefix => appgws if appgws.appgw_turn_on == true }
  resource_group_name  = module.spoke_networking.spoke_rg_name
  virtual_network_name = module.spoke_networking.spoke_vnet_name
  location             = module.spoke_networking.spoke_rg_location
  appgw_name           = "${each.value.name_prefix}-appgw"
  frontend_subnet      = module.spoke_networking.subnet_ids["appgwsubnet"]
  appgw_pip            = module.pip[each.key].public_ip_id
  tags                 = var.spoke_tags
  depends_on = [
    module.appgw_nsg
  ]
}

module "pip" {
  source = "./modules/pip"

  for_each            = { for appgws in local.appgws : appgws.name_prefix => appgws if appgws.appgw_turn_on == true }
  pip_name            = "${each.value.name_prefix}-appgw-pip"
  resource_group_name = module.spoke_networking.spoke_rg_name
  location            = module.spoke_networking.spoke_rg_location
  tags                = var.spoke_tags
}

# Create EID groups. Use if SPN is allowed to create EID groups.
module "aks_eid_groups" {
  source = "./modules/EID_groups"

  aks_admins_group = var.aks_admins_group
  aks_users_group  = var.aks_users_group
}

# # Deploy Public DNS to register application domains hosted in AKS. 
# # If you are not planning to use the blue green deployment, then you don't need to deploy the public DNS Zone and you can skip this leaving empty the variable public_domain.
# resource "azurerm_dns_zone" "public-dns-apps" {
#   count               = var.public_domain != "" ? 1 : 0
#   name                = var.public_domain
#   resource_group_name = module.spoke_networking.spoke_rg_name
#   tags                = var.spoke_tags

#   depends_on = [
#     module.spoke_networking
#   ]
# }

# module "laws" {
#   source = "./modules/laws"

#   workspace_name      = "${var.aks_appname}-laws"
#   resource_group_name = module.spoke_networking.spoke_rg_name
#   location            = module.spoke_networking.spoke_rg_location
#   sku                 = "PerGB2018"
#   tags                = var.spoke_tags
#   retention_in_days   = 30
#   depends_on = [
#     module.spoke_networking
#   ]
# }

# # MSI for Kubernetes Cluster (Control Plane)
# # This ID is used by the AKS control plane to create or act on other resources in Azure.
# # It is referenced in the "identity" block in the azurerm_kubernetes_cluster resource.
# # Based on the structure of the aks_clusters map is created an identity per each AKS Cluster, this is mainly used in the blue green deployment scenario.

module "uami_aks_cp" {
  source = "./modules/uami"

  for_each            = { for aks_clusters in local.aks_clusters : aks_clusters.name_prefix => aks_clusters if aks_clusters.aks_turn_on == true }
  uami_name           = "${var.aks_appname}${each.value.name_prefix}-mi-cp"
  resource_group_name = module.spoke_networking.spoke_rg_name
  location            = module.spoke_networking.spoke_rg_location
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "role_assignment_aks-to-vnet" {
  source = "./modules/role_assignment"

  for_each                 = module.uami_aks_cp
  user_assigned_identities = module.uami_aks_cp
  scope                    = module.spoke_networking.spoke_vnet_id
  role_definition_name     = "Network Contributor"
  depends_on = [
    module.spoke_networking,
    module.uami_aks_cp
  ]
}

module "aks_dns_zone" {
  source = "./modules/dns_zone"

  dns_zone_name       = "privatelink.northeurope.azmk8s.io"
  resource_group_name = module.spoke_networking.spoke_rg_name
  vnet_link_name      = "hub_to_aks"
  virtual_network_id  = data.terraform_remote_state.hub-vnet_tfstate.outputs.hub_vnet_id
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "role_assignment_aks-to-dnszone" {
  source = "./modules/role_assignment"

  for_each                 = module.uami_aks_cp
  user_assigned_identities = module.uami_aks_cp
  scope                    = module.aks_dns_zone.dns_zone_id
  role_definition_name     = "Private DNS Zone Contributor"
  depends_on = [
    module.spoke_networking,
    module.uami_aks_cp,
    module.aks_dns_zone
  ]
}

module "role_assignment_aks-to-rt" {
  source = "./modules/role_assignment"

  for_each                 = module.uami_aks_cp
  user_assigned_identities = module.uami_aks_cp
  scope                    = module.spoke_networking.rt_ids["akssubnet"]
  role_definition_name     = "Contributor"
  depends_on = [
    module.spoke_networking,
    module.uami_aks_cp,
    module.aks_dns_zone
  ]
}

# # # These resources will set up the required permissions for 
# # # Microsoft Entra Pod Identity (v1)

module "uami_aks_pod" {
  source = "./modules/uami"

  uami_name           = "pod-identity"
  resource_group_name = module.spoke_networking.spoke_rg_name
  location            = module.spoke_networking.spoke_rg_location
  tags                = var.spoke_tags
  depends_on = [
    module.spoke_networking
  ]
}

module "aad_pod_identity_access_policy" {
  source = "./modules/kv_access_policy"

  key_vault_id       = module.kv.kv_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = module.uami_aks_pod.principal_id
  secret_permissions = ["Get", "List"]
}

module "aks" {
  source = "./modules/aks-private"

  for_each               = { for aks_clusters in local.aks_clusters : aks_clusters.name_prefix => aks_clusters if aks_clusters.aks_turn_on == true }
  resource_group_name    = module.spoke_networking.spoke_rg_name
  admin_group_object_ids = module.aks_eid_groups.aksadmins_object_id
  maintenance_window     = var.maintenance_window
  location               = module.spoke_networking.spoke_rg_location
  prefix                 = "${var.aks_appname}-${each.value.name_prefix}"
  vnet_subnet_id         = module.spoke_networking.subnet_ids["akssubnet"]
  mi_aks_cp_id           = module.uami_aks_cp[each.value.name_prefix].id
  #   la_id                  = module.laws.log_analytics_workspace_id
  gateway_name        = module.appgw[each.key].gateway_name
  gateway_id          = module.appgw[each.key].gateway_id
  private_dns_zone_id = module.aks_dns_zone.dns_zone_id
  network_plugin      = try(var.network_plugin, "azure")
  pod_cidr            = try(var.pod_cidr, null)
  k8s_version         = each.value.k8s_version
  tags                = var.spoke_tags

  depends_on = [
    module.role_assignment_aks-to-vnet,
    module.role_assignment_aks-to-dnszone
  ]
}

# Route table to support AKS cluster with kubenet network plugin

resource "azurerm_route_table" "rt" {
  count                         = var.network_plugin == "kubenet" ? 1 : 0
  name                          = "appgw-rt"
  resource_group_name           = module.spoke_networking.spoke_rg_name
  location                      = module.spoke_networking.spoke_rg_location
  bgp_route_propagation_enabled = true
  depends_on = [
    module.aks
  ]
}

resource "azurerm_subnet_route_table_association" "rt_kubenet_association" {
  count          = var.network_plugin == "kubenet" ? 1 : 0
  subnet_id      = module.spoke_networking.subnet_ids["akssubnet"]
  route_table_id = azurerm_route_table.rt[count.index].id
  depends_on = [
    azurerm_route_table.rt
  ]
}

# # # These role assignments grant the EID groups access.

# # The AKS cluster. 
# # Based on the instances of AKS Clusters deployed are defined the role assignments per each cluster, this is mainly used in the blue green deployment scenario.

module "eid_role_assignment-aks_users" {
  source = "./modules/EID_role_assignment"

  for_each             = { for k, v in module.aks : k => v }
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = each.value.aks_id
  eid_group_ids = [
    module.aks_eid_groups.aksusers_object_id
  ]
}

module "eid_role_assignment-aks_admins" {
  source = "./modules/EID_role_assignment"

  for_each             = { for k, v in module.aks : k => v }
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = each.value.aks_id
  eid_group_ids = [
    module.aks_eid_groups.aksadmins_object_id
  ]
}

module "eid_role_assignment-aks_rbac_admin" {
  source = "./modules/EID_role_assignment"

  for_each             = { for k, v in module.aks : k => v }
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = each.value.aks_id
  eid_group_ids = [
    data.azurerm_client_config.current.object_id
  ]
}

# # Role Assignment to Azure Container Registry from AKS Cluster
# # This must be granted after the cluster is created in order to use the kubelet identity.
# # Based on the instances of AKS Clusters deployed are defined the role assignments per each cluster, this is mainly used in the blue green deployment scenario.

module "role_assignment_aks-to-acr" {
  source = "./modules/role_assignment"

  for_each = module.aks
  user_assigned_identities = {
    (each.key) = {
      principal_id = each.value.kubelet_id
    }
  }
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  depends_on = [
    module.aks
  ]
}

# # Role Assignments for AGIC on AppGW
# # This must be granted after the cluster is created in order to use the ingress identity.
# # Based on the instances of AKS Clusters deployed are defined the role assignments per each cluster, this is mainly used in the blue green deployment scenario.

module "role_assignment_agic_appgw" {
  source = "./modules/role_assignment"

  for_each = module.aks
  user_assigned_identities = {
    (each.key) = {
      principal_id = each.value.agic_id
    }
  }
  scope                = each.value.appgw_id
  role_definition_name = "Contributor"
  depends_on = [
    module.aks
  ]
}

# Role assignments
# Based on the instances of AKS Clusters deployed are defined the role assignments per each cluster, this is mainly used in the blue green deployment scenario.

module "role_assignment_aks_identity_operator" {
  source = "./modules/role_assignment"

  for_each = module.aks
  user_assigned_identities = {
    (each.key) = {
      principal_id = each.value.kubelet_id
    }
  }
  scope                = module.uami_aks_pod.id
  role_definition_name = "Managed Identity Operator"
  depends_on = [
    module.aks
  ]
}

module "role_assignment_aks_vm_contributor" {
  source = "./modules/role_assignment"

  for_each = module.aks
  user_assigned_identities = {
    (each.key) = {
      principal_id = each.value.kubelet_id
    }
  }
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.node_pool_rg}"
  role_definition_name = "Virtual Machine Contributor"
  depends_on = [
    module.aks
  ]
}