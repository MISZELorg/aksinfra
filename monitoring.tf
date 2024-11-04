# resource "azurerm_resource_group" "monitoring_rg" {
#   name     = "${var.aks_appname}-monitoring-rg"
#   location = var.location
#   tags     = var.spoke_tags
# }

# resource "azurerm_log_analytics_workspace" "laws" {
#   name                = "${var.aks_appname}-laws"
#   resource_group_name = azurerm_resource_group.monitoring_rg.name
#   location            = azurerm_resource_group.monitoring_rg.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   tags                = var.spoke_tags
#   depends_on = [
#     azurerm_resource_group.monitoring_rg
#   ]
# }

# resource "azurerm_monitor_workspace" "aks_amw" {
#   name                = "${var.aks_appname}-amw"
#   resource_group_name = azurerm_resource_group.monitoring_rg.name
#   location            = azurerm_resource_group.monitoring_rg.location
#   tags                = var.spoke_tags
#   depends_on = [
#     azurerm_resource_group.monitoring_rg
#   ]
# }

# resource "azurerm_dashboard_grafana" "aks_grafana" {
#   name                              = "${var.aks_appname}-grafana"
#   resource_group_name               = azurerm_resource_group.monitoring_rg.name
#   location                          = azurerm_resource_group.monitoring_rg.location
#   grafana_major_version             = 10
#   api_key_enabled                   = false
#   deterministic_outbound_ip_enabled = false
#   public_network_access_enabled     = true
#   tags                              = var.spoke_tags
#   azure_monitor_workspace_integrations {
#     resource_id = azurerm_monitor_workspace.aks_amw.id
#   }
#   identity {
#     type = "SystemAssigned"
#   }
#   depends_on = [
#     azurerm_monitor_workspace.aks_amw
#   ]
# }

# resource "azurerm_role_assignment" "role_grafana_admin" {
#   scope                = azurerm_dashboard_grafana.grafana.id
#   role_definition_name = "Grafana Admin"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurerm_role_assignment" "aks_readerrole" {
#   scope              = azurerm_monitor_workspace.aks_amw.id
#   role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/b0d8363b-8ddd-447d-831f-62ca05bff136"
#   principal_id       = azurerm_dashboard_grafana.aks_grafana.identity.0.principal_id
#   depends_on = [
#     azurerm_monitor_workspace.aks_amw,
#     azurerm_dashboard_grafana.aks_grafana
#   ]
# }

# resource "azurerm_role_assignment" "role_monitoring_reader" {
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = "Monitoring Reader"
#   principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
# }

# resource "azurerm_monitor_data_collection_endpoint" "aks_dce" {
#   name                = "${var.aks_appname}-dce"
#   resource_group_name = azurerm_resource_group.monitoring_rg.name
#   location            = azurerm_resource_group.monitoring_rg.location
#   kind                = "Linux"
#   tags                = var.spoke_tags
# }

# resource "azurerm_monitor_data_collection_rule" "aks_promdcr" {
#   name                        = "MSProm-${azurerm_resource_group.monitoring_rg.location}-${var.aks_appname}"
#   resource_group_name         = azurerm_resource_group.monitoring_rg.name
#   location                    = azurerm_resource_group.monitoring_rg.location
#   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.aks_dce.id
#   tags                        = var.spoke_tags
#   depends_on = [
#     azurerm_monitor_data_collection_endpoint.aks_dce,
#     azurerm_monitor_workspace.aks_amw
#   ]

#   destinations {
#     monitor_account {
#       monitor_account_id = azurerm_monitor_workspace.aks_amw.id
#       name               = "MonitoringAccount1"
#     }
#   }

#   data_flow {
#     streams      = ["Microsoft-PrometheusMetrics"]
#     destinations = ["MonitoringAccount1"]
#   }

#   data_sources {
#     prometheus_forwarder {
#       streams = ["Microsoft-PrometheusMetrics"]
#       name    = "PrometheusDataSource"
#     }
#   }
# }

# resource "azurerm_monitor_data_collection_rule" "aks_cidcr" {
#   name                = "MSCI-${azurerm_resource_group.monitoring_rg.location}-${var.aks_appname}"
#   resource_group_name = azurerm_resource_group.monitoring_rg.name
#   location            = azurerm_resource_group.monitoring_rg.location
#   tags                = var.spoke_tags
#   depends_on = [
#     azurerm_log_analytics_workspace.laws
#   ]

#   destinations {
#     log_analytics {
#       workspace_resource_id = azurerm_log_analytics_workspace.laws.id
#       name                  = "ciworkspace"
#     }
#   }

#   data_flow {
#     streams      = var.streams
#     destinations = ["ciworkspace"]
#   }

#   data_flow {
#     streams      = ["Microsoft-Syslog"]
#     destinations = ["ciworkspace"]
#   }

#   data_sources {
#     syslog {
#       streams        = ["Microsoft-Syslog"]
#       facility_names = var.syslog_facilities
#       log_levels     = var.syslog_levels
#       name           = "sysLogsDataSource"
#     }

#     extension {
#       streams        = var.streams
#       extension_name = "ContainerInsights"
#       extension_json = jsonencode({
#         "dataCollectionSettings" : {
#           "interval" : var.data_collection_interval,
#           "namespaceFilteringMode" : var.namespace_filtering_mode_for_data_collection,
#           "namespaces" : var.namespaces_for_data_collection
#           "enableContainerLogV2" : var.enableContainerLogV2
#         }
#       })
#       name = "ContainerInsightsExtension"
#     }
#   }
# }

# module "aks-monitoring" {
#   source = "./modules/aks-monitoring"

#   resource_group_name = "${var.aks_appname}-monitoring-rg"
#   location            = module.spoke_networking.spoke_rg_location
#   tags                = var.spoke_tags
#   amw_name            = "${var.aks_appname}-amw"
#   grafana_name        = "${var.aks_appname}-grafana"
#   dce_name            = "${var.aks_appname}-dce"
#   prometheus_dcr_name = "MSProm-${module.aks-monitoring.location}-${var.aks_appname}"
#   ci_dcr_name         = "MSCI-${module.aks-monitoring.location}-${var.aks_appname}"
#   workspace_id        = module.laws.log_analytics_workspace_id

#   depends_on = [
#     module.aks
#   ]
# }

# module "eid_role_assignment-grafana_admin" {
#   source = "./modules/EID_role_assignment"

#   role_definition_name = "Grafana Admin"
#   scope                = module.aks-monitoring.grafana_id
#   eid_group_ids = [
#     module.aks_eid_groups.aksadmins_object_id
#   ]
#   depends_on = [
#     module.aks-monitoring
#   ]
# }

# module "eid_role_assignment-grafana_viewer" {
#   source = "./modules/EID_role_assignment"

#   role_definition_name = "Grafana Viewer"
#   scope                = module.aks-monitoring.grafana_id
#   eid_group_ids = [
#     module.aks_eid_groups.aksusers_object_id
#   ]
#   depends_on = [
#     module.aks-monitoring
#   ]
# }

# resource "azurerm_monitor_data_collection_rule_association" "aks_amwdcra" {
#   for_each                = { for k, v in module.aks : k => v }
#   name                    = "MSProm-${module.aks-monitoring.location}-${var.aks_appname}"
#   target_resource_id      = each.value.aks_id
#   data_collection_rule_id = module.aks-monitoring.promdcr_id
#   depends_on = [
#     module.aks-monitoring,
#     module.aks
#   ]
# }

# resource "azurerm_monitor_data_collection_rule_association" "aks_cidcra" {
#   for_each                = { for k, v in module.aks : k => v }
#   name                    = "MSCi-${module.aks-monitoring.location}-${var.aks_appname}"
#   target_resource_id      = each.value.aks_id
#   data_collection_rule_id = module.aks-monitoring.cidcr_id
#   depends_on = [
#     module.aks-monitoring,
#     module.aks
#   ]
# }