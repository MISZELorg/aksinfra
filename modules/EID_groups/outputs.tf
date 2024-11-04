output "aksadmins_object_id" {
  value = azuread_group.aksadmins.object_id
}

output "aksusers_object_id" {
  value = azuread_group.aksusers.object_id
}