output "eid_role_assignment_ids" {
  description = "The IDs of the created role assignments for EID groups."
  value       = [for ra in azurerm_role_assignment.eid_group_assignment : ra.id]
}
