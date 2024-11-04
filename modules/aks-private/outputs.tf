output "aks_id" {
  value = azurerm_kubernetes_cluster.akscluster.id
}

output "node_pool_rg" {
  value = azurerm_kubernetes_cluster.akscluster.node_resource_group
}

# Managed Identities created for Addons

output "kubelet_id" {
  value = azurerm_kubernetes_cluster.akscluster.kubelet_identity.0.object_id
}

output "agic_id" {
  value = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway.0.ingress_application_gateway_identity.0.object_id
}

output "appgw_id" {
  value = var.gateway_id
}