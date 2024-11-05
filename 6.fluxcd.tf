resource "azurerm_kubernetes_cluster_extension" "flux" {
  for_each       = { for k, v in module.aks : k => v }
  name           = "flux"
  cluster_id     = each.value.aks_id
  extension_type = "microsoft.flux"

  #   configuration_protected_settings = {
  #     gitRepositorySecret = var.flux
  #   }

  depends_on = [
    module.aks
  ]
}

resource "azurerm_kubernetes_flux_configuration" "example" {
  for_each   = { for k, v in module.aks : k => v }
  name       = "fluxconf"
  cluster_id = each.value.aks_id
  namespace  = "flux"

  git_repository {
    url             = "https://github.com/MISZELorg/aksapps"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "kustomization-1"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]
}