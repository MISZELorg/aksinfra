variable "user_assigned_identities" {
  description = "A map of user assigned identities for role assignments."
  type = map(object({
    principal_id = string
  }))
}

variable "scope" {
  description = "The scope at which the role assignment applies."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the role definition to assign."
  type        = string
}
