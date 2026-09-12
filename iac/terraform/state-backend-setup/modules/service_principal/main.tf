# Use random string to create naming suffix
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}
# data "azuread_client_config" "current" {}

locals {
  naming_string = random_string.this.result
  owner_id = var.owner_id != null ? var.owner_id : data.azuread_client_config.current.object_id
}

####################################################################


# Create a custom role with ABAC
resource "azurerm_role_definition" "this" {
  count = (var.is_custom_RBAC ==true) ? 1 : 0
  name        = "RBAC-${var.RBAC_name}-${local.naming_string}"
  scope       = var.role_definition_scope #data.azurerm_subscription.this.id
  description = var.description

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action"
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
  }

  assignable_scopes = var.assignable_scopes
}
#############################################

data "azuread_client_config" "current" {}

#### 2. create the application 
resource "azuread_application_registration" "this" {

  display_name = coalesce(var.identity_name, "App-${var.RBAC_name}-${local.naming_string}")
}

#### 3. create the service principal
resource "azuread_service_principal" "this" {

  client_id                    = azuread_application_registration.this.client_id
  app_role_assignment_required = false
  owners                       = [local.owner_id]
}

#### 4. assign the role to the service principal

resource "azurerm_role_assignment" "this" {
  count = var.is_custom_RBAC ? 1 : 0
    scope                = var.role_assignment_scope #azurerm_storage_account.this.id
  role_definition_name = azurerm_role_definition.this[0].name
    principal_id         = azuread_service_principal.this.object_id

    #### 5. ABAC condition condition.tpl
    # ${path.module} output the filesystem path of the current Terraform module.
    # the folder the module in `state-backend-setup`
    condition = templatefile(var.condition_tpl, var.condition_tpl_vars)

  condition_version                = "2.0"
  skip_service_principal_aad_check = true

  depends_on = [azurerm_role_definition.this] # custom RBAC
}

resource "azurerm_role_assignment" "user_storage_access" {
    count = (var.is_custom_RBAC == false) ? 1 : 0
  scope                = var.role_assignment_scope
  role_definition_name = var.buildIn_role_definition_name
  principal_id         = azuread_service_principal.this.object_id
}

