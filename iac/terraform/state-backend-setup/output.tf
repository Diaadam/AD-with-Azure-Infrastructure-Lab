output "storage_srv_principal_role_name" {
  value = module.storage_srv_principal.role_name
}
output "storage_srv_principal_client_id" {
  value = module.storage_srv_principal.client_id
}
output "storage_srv_principal_tenant_id" {
  value = module.storage_srv_principal.tenant_id
}
output "storage_srv_principal" {
  value       = module.storage_srv_principal.service_principal
  description = "The full service principal object associated with the application."
}

output "storage_srv_principal_azuread_application_display_name" {
  value       = module.storage_srv_principal.azuread_application_display_name
}
output "storage_srv_principal_azuread_application_id" {
  value       = module.storage_srv_principal.azuread_application_id
}
##################################################################################
output "oidc_srv_principal_role_name" {
  value = module.oidc_srv_principal.role_name
}
output "oidc_srv_principal_client_id" {
  value = module.oidc_srv_principal.client_id
}
output "oidc_srv_principal_tenant_id" {
  value = module.oidc_srv_principal.tenant_id
}
output "oidc_srv_principal_service_principal" {
  value       = module.oidc_srv_principal.service_principal
  description = "The full service principal object associated with the application."
}

output "oidc_srv_principal_azuread_application_display_name" {
  value       = module.oidc_srv_principal.azuread_application_display_name
}
output "oidc_srv_principal_azuread_application_id" {
  value       = module.oidc_srv_principal.azuread_application_id
}
#########################################################################################
output "subscription_id" {
  value = data.azurerm_subscription.this.subscription_id
}
