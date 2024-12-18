resource "azurerm_user_assigned_identity" "uami" {
  name                = var.uami_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}