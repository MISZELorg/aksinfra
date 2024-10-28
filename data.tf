# data "terraform_remote_state" "hub-vnet_tfstate" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = var.state_sa_name
#     container_name       = var.container_name
#     subscription_id      = var.hub_sub_id
#     resource_group_name  = var.hub_rg_name
#     key                  = var.key
#   }
# }