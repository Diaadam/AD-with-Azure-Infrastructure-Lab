output "role_name" {
  value = var.is_custom_RBAC ? azurerm_role_definition.this[0].name : var.buildIn_role_definition_name
}

output "client_id" {
  value = azuread_application_registration.this.client_id
}


output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

##################################################################
output "service_principal" {
  value       = azuread_service_principal.this
  description = "The full service principal object associated with the application."
}

output "azuread_application_display_name" {
  value       = azuread_application_registration.this.display_name

}

output "azuread_application_id" {
  value       = azuread_application_registration.this.id
}

