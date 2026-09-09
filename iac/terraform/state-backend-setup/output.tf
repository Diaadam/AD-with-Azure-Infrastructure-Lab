output "storage_account_name" {
  value = azurerm_storage_account.backend_storage.name
}

output "storage_container_name" {
  value = azurerm_storage_container.backend_storage.name
}

output "role_name" {
  value = azurerm_role_definition.backend_storage.name
}

output "service_principal" {
  value = azuread_service_principal.backend_storage
}

output "subscription_id" {
  value = data.azurerm_subscription.backend_storage.subscription_id
}


output "client_id" {
  value = azuread_application.backend_storage.client_id
}

output "client_secret" {
  value     = azuread_service_principal_password.backend_storage.value
  sensitive = true
}

output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}