variable "key_vault_id" {
  description = "The ID of the Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "The Tenant ID"
  type        = string
}

variable "object_id" {
  description = "The Object ID of the User Assigned Managed Identity"
  type        = string
}

variable "secret_permissions" {
  description = "List of secret permissions for the access policy"
  type        = list(string)
  default     = []
}
