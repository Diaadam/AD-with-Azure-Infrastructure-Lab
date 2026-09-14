# Get the current subscription
data "azurerm_subscription" "this" {}

module "storage" {
  source = "./modules/storage"

  container_name = var.container_name
  tags           = var.tags
}

module "storage_srv_principal" {
  source = "./modules/service_principal"

  RBAC_name            = "storage"
  description          = "Custom role definition allowing write access to the storage account ${module.storage.storage_account_name}."
  role_definition_scope = data.azurerm_subscription.this.id
  assignable_scopes     = [data.azurerm_subscription.this.id]
  role_assignment_scope = module.storage.storage_account_id
  condition_tpl         = "${path.root}/conditions/storage_condition.tpl"
  condition_tpl_vars    = {
    container_name = module.storage.storage_container_name
    state_path     = "${var.env}-tfstate"
  }
}

module "oidc_srv_principal" {
  source = "./modules/service_principal"

  RBAC_name            = "oidc"
  description          = "Role definition allowing access from GitHub Actions on the repo ${var.repository_name}."
  is_custom_RBAC       = false
  role_definition_scope = data.azurerm_subscription.this.id
  assignable_scopes     = [data.azurerm_subscription.this.id]
  role_assignment_scope = module.storage.storage_account_id
  buildIn_role_definition_name = "Storage Blob Data Contributor"
}

module "oidc" {
  source = "./modules/oidc"

  repository_name                  = var.repository_name
  azuread_application_id           = module.oidc_srv_principal.azuread_application_id
  azuread_application_display_name = module.oidc_srv_principal.azuread_application_display_name
  entity_type                      = var.entity_type
  environment_names                = var.environment_names
}

