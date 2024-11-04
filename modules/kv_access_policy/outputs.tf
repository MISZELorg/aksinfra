output "access_policy_id" {
  description = "The ID of the Key Vault Access Policy"
  value       = azurerm_key_vault_access_policy.kv_access_policy.id
}
