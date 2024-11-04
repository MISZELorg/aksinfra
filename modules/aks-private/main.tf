# Creates cluster with default linux node pool

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = var.prefix
  dns_prefix          = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  # node_resource_group          = "${var.prefix}-${var.location}-node-rg"
  automatic_upgrade_channel           = "patch"
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 168
  kubernetes_version                  = var.k8s_version
  private_cluster_enabled             = true
  private_dns_zone_id                 = var.private_dns_zone_id
  azure_policy_enabled                = true
  private_cluster_public_fqdn_enabled = false
  tags                                = var.tags

  ingress_application_gateway {
    gateway_id = var.gateway_id
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id      = var.la_id
    msi_auth_for_monitoring_enabled = true
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  maintenance_window_auto_upgrade {
    frequency   = var.maintenance_window["frequency"]
    duration    = tonumber(var.maintenance_window["duration"])
    interval    = tonumber(var.maintenance_window["interval"])
    day_of_week = var.maintenance_window["day_of_week"]
    start_time  = var.maintenance_window["start_time"]
    start_date  = var.maintenance_window["start_date"]
    utc_offset  = var.maintenance_window["utc_offset"]
  }

  maintenance_window_node_os {
    frequency   = var.maintenance_window["frequency"]
    duration    = tonumber(var.maintenance_window["duration"])
    interval    = tonumber(var.maintenance_window["interval"])
    day_of_week = var.maintenance_window["day_of_week"]
    start_time  = var.maintenance_window["start_time"]
    start_date  = var.maintenance_window["start_date"]
    utc_offset  = var.maintenance_window["utc_offset"]
  }

  default_node_pool {
    name                        = "defaultpool"
    temporary_name_for_rotation = "temppool"
    vm_size                     = "Standard_DS2_v2"
    os_disk_size_gb             = 30
    type                        = "VirtualMachineScaleSets"
    node_count                  = 2
    min_count                   = 2
    max_count                   = 3
    max_pods                    = 30
    vnet_subnet_id              = var.vnet_subnet_id
    auto_scaling_enabled        = true

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  network_profile {
    network_plugin = var.network_plugin
    outbound_type  = "userDefinedRouting"
    dns_service_ip = "192.168.100.10"
    service_cidr   = "192.168.100.0/24"
    pod_cidr       = var.pod_cidr
  }

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    admin_group_object_ids = [
      var.admin_group_object_ids
      # data "azuread_group" "k8s_admins" { # Use when refering to existing EID group.
      #   display_name = "k8s_admins"
      # }
    ]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.mi_aks_cp_id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

# not finished

# resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_userpool" {
#   for_each              = var.node_pool_config
#   name                  = each.value.name
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
#   vm_size               = each.value.vm_size
#   vnet_subnet_id        = azurerm_subnet.aks_subnet.id
#   auto_scaling_enabled  = each.value.auto_scaling_enabled
#   zones                 = each.value.zones
#   node_count            = each.value.node_count
#   min_count             = each.value.min_count
#   max_count             = each.value.max_count
#   max_pods              = each.value.max_pods
#   mode                  = each.value.mode
#   tags                  = var.aks_tags
#   depends_on = [
#     azurerm_resource_group.aks_rg,
#     azurerm_kubernetes_cluster.aks_cluster
#   ]
# }