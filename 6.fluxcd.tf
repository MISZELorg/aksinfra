resource "azurerm_kubernetes_cluster_extension" "flux" {
  for_each       = { for k, v in module.aks : k => v }
  name           = "flux_ext"
  cluster_id     = each.value.aks_id
  extension_type = "microsoft.flux"
  depends_on = [
    module.aks
  ]
}
resource "azurerm_kubernetes_flux_configuration" "example" {
  for_each   = { for k, v in module.aks : k => v }
  name       = "flux_config"
  cluster_id = each.value.aks_id
  namespace  = "flux"
  git_repository {
    url                    = var.github_repo
    reference_type         = "branch"
    reference_value        = "main"
    ssh_private_key_base64 = base64encode(var.ssh_private_key)
  }
  kustomizations {
    name = "kustomization-1"
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]
}