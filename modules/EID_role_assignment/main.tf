# resource "azurerm_role_assignment" "eid_group_assignment" {
#   for_each             = toset(var.eid_group_ids)
#   scope                = var.scope
#   role_definition_name = var.role_definition_name
#   principal_id         = each.value
# }

resource "azurerm_role_assignment" "eid_group_assignment" {
  for_each = { for idx, id in var.eid_group_ids : idx => id }

  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = each.value
}