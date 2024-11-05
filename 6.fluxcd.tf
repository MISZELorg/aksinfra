# resource "azurerm_kubernetes_cluster_extension" "flux" {
#   for_each             = { for k, v in module.aks : k => v }
#   name                 = "flux"
#   cluster_id = each.value.aks_id
#   extension_type       = "microsoft.flux"
#   version              = "1.0" # Set the version you need, if applicable

#     configuration_protected_settings = {
#     gitRepositorySecret = var.flux_key
#   }

#   depends_on = [
#     module.aks
#   ]
# }