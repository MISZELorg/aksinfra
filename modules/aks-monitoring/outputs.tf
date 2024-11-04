output "grafana_id" {
  description = "ID of the Grafana"
  value       = azurerm_dashboard_grafana.aks_grafana.id
}

output "principal_id" {
  description = "The Principal ID of Grafana"
  value       = azurerm_dashboard_grafana.aks_grafana.identity
}

output "amw_id" {
  description = "ID of the Azure Monitor Workspace"
  value       = azurerm_monitor_workspace.aks_amw.id
}

output "location" {
  description = "Monitoring RG location"
  value       = azurerm_resource_group.monitoring_rg.location
}

output "promdcr_id" {
  description = "xxx"
  value       = azurerm_monitor_data_collection_rule.aks_promdcr.id
}

output "cidcr_id" {
  description = "xxx"
  value       = azurerm_monitor_data_collection_rule.aks_cidcr.id
}

