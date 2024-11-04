data "azurerm_client_config" "current" {}

data "terraform_remote_state" "hub-vnet_tfstate" {
  backend = "azurerm"

  config = {
    storage_account_name = var.hub_state_sa_name
    container_name       = var.hub_state_container_name
    subscription_id      = var.hub_state_sub_id
    resource_group_name  = var.hub_state_rg_name
    key                  = var.hub_state_key
    use_oidc             = true
  }
}

# Use when refering to existing EID group in AKS 
# data "azuread_group" "k8s_admins" {
#   display_name = "k8s_admins"
# }