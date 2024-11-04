output "role_assignment_ids" {
  description = "The IDs of the created role assignments."
  value       = [for ra in azurerm_role_assignment.assignment : ra.id]
}
