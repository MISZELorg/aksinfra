variable "eid_group_ids" {
  description = "A list of AAD group object IDs for role assignments."
  type        = list(string)
}

variable "scope" {
  description = "The scope at which the role assignment applies."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the role definition to assign."
  type        = string
}
