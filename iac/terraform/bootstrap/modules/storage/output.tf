output "storage_account_name" {
  value = azurerm_storage_account.backend_storage.name
}

output "storage_resource_group_name" {
  value = azurerm_resource_group.backend_storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.backend_storage.id
}

output "storage_container_name" {
  value = azurerm_storage_container.backend_storage.name
}
