resource "azurerm_role_assignment" "assignment" {
  for_each             = var.user_assigned_identities
  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = each.value.principal_id
}
