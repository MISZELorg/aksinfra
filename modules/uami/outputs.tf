output "id" {
  description = "The ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.uami.id
}

output "client_id" {
  description = "The Client ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.uami.client_id
}

output "principal_id" {
  description = "The Principal ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.uami.principal_id
}
