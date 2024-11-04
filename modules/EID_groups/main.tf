resource "azuread_group" "aksadmins" {
  display_name     = var.aks_admins_group
  security_enabled = true
}

resource "azuread_group" "aksusers" {
  display_name     = var.aks_users_group
  security_enabled = true
}