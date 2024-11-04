resource "azurerm_role_assignment" "eid_group_assignment" {
  for_each             = toset(var.eid_group_ids)
  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = each.value
}

output "role_assignment_ids" {
  description = "The IDs of the created role assignments for EID groups."
  value       = [for ra in azurerm_role_assignment.eid_group_assignment : ra.id]
}
