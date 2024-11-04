resource "azurerm_resource_group" "monitoring_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_monitor_workspace" "aks_amw" {
  name                = var.amw_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  location            = azurerm_resource_group.monitoring_rg.location
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.monitoring_rg
  ]
}

resource "azurerm_dashboard_grafana" "aks_grafana" {
  name                              = var.grafana_name
  resource_group_name               = azurerm_resource_group.monitoring_rg.name
  location                          = azurerm_resource_group.monitoring_rg.location
  grafana_major_version             = 10
  api_key_enabled                   = false
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  tags                              = var.tags
  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.aks_amw.id
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_monitor_workspace.aks_amw
  ]
}

resource "azurerm_role_assignment" "role_monitoring_data_reader" {
  scope                = azurerm_monitor_workspace.aks_amw.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.aks_grafana.identity.0.principal_id
  depends_on = [
    azurerm_dashboard_grafana.aks_grafana,
  azurerm_monitor_workspace.aks_amw]
}

resource "azurerm_role_assignment" "role_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.aks_grafana.identity.0.principal_id
  depends_on = [
    azurerm_dashboard_grafana.aks_grafana
  ]
}

resource "azurerm_monitor_data_collection_endpoint" "aks_dce" {
  name                = var.dce_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  location            = azurerm_resource_group.monitoring_rg.location
  kind                = "Linux"
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_rule" "aks_promdcr" {
  name                        = var.prometheus_dcr_name
  resource_group_name         = azurerm_resource_group.monitoring_rg.name
  location                    = azurerm_resource_group.monitoring_rg.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.aks_dce.id
  tags                        = var.tags
  depends_on = [
    azurerm_monitor_data_collection_endpoint.aks_dce,
    azurerm_monitor_workspace.aks_amw
  ]

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.aks_amw.id
      name               = "MonitoringAccount1"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }
}

resource "azurerm_monitor_data_collection_rule" "aks_cidcr" {
  name                = var.ci_dcr_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  location            = azurerm_resource_group.monitoring_rg.location
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = var.workspace_id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = var.streams
    destinations = ["ciworkspace"]
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["ciworkspace"]
  }

  data_sources {
    syslog {
      streams        = ["Microsoft-Syslog"]
      facility_names = var.syslog_facilities
      log_levels     = var.syslog_levels
      name           = "sysLogsDataSource"
    }

    extension {
      streams        = var.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : var.data_collection_interval,
          "namespaceFilteringMode" : var.namespace_filtering_mode_for_data_collection,
          "namespaces" : var.namespaces_for_data_collection
          "enableContainerLogV2" : var.enableContainerLogV2
        }
      })
      name = "ContainerInsightsExtension"
    }
  }
}