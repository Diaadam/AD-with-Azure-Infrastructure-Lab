# Use random string to create naming suffix
resource "random_string" "backend_storage" {
  length  = 6
  special = false
  upper   = false
}

locals {
  naming_string = "backendstorage${random_string.backend_storage.result}"
  state_path = "${var.env}-tfstate"
  common_tags = {
        environment = var.env
    }
}

# Create resource group
resource "azurerm_resource_group" "backend_storage" {
  name     = local.naming_string
  location = "uaenorth"
  tags = local.common_tags
}

# Create storage account
resource "azurerm_storage_account" "backend_storage" {
  name                     = local.naming_string
  location                 = azurerm_resource_group.backend_storage.location
  resource_group_name      = azurerm_resource_group.backend_storage.name
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  min_tls_version                = "TLS1_2"
  shared_access_key_enabled      = false # diable account keys and use sas
  default_to_oauth_authentication = true
  infrastructure_encryption_enabled = false
  
  blob_properties {
    versioning_enabled       = true
    change_feed_enabled      = true
    change_feed_retention_in_days = 30
    last_access_time_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }
    sas_policy {
    expiration_period = "00.02:00:00" # def:2 hours
    expiration_action = "Log"
  }
    tags = local.common_tags
}



# Create containers in the storage account
resource "azurerm_storage_container" "backend_storage" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend_storage.id
  container_access_type = "private" # restrict public access (networking)
}


####################################################################
# Get the current subscription
data "azurerm_subscription" "backend_storage" {}

# Create a custom role with ABAC
resource "azurerm_role_definition" "backend_storage" {
  name        = "${local.naming_string}-write-access"
  scope       = data.azurerm_subscription.backend_storage.id
  description = "Custom role definition allowing write access to the storage account ${azurerm_storage_account.backend_storage.name}."

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

  assignable_scopes = [
    data.azurerm_subscription.backend_storage.id
  ]
}
#############################################

data "azuread_client_config" "current" {}

#### 2. create the application 
resource "azuread_application" "backend_storage" {
  display_name = local.naming_string
  owners       = [data.azuread_client_config.current.object_id]
}

#### 3. create the service principal
resource "azuread_service_principal" "backend_storage" {
  client_id                    = azuread_application.backend_storage.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "backend_storage" {
  service_principal_id = azuread_service_principal.backend_storage.id
}

#### 4. assign the role to the service principal

resource "azurerm_role_assignment" "backend_storage" {
    scope                = azurerm_storage_account.backend_storage.id
    role_definition_name = azurerm_role_definition.backend_storage.name
    principal_id         = azuread_service_principal.backend_storage.object_id

    #### 5. ABAC condition condition.tpl
    # ${path.module} output the filesystem path of the current Terraform module.
    # the folder the module in `state-backend-setup`
    condition = templatefile("${path.module}/condition.tpl", {
    container_name = azurerm_storage_container.backend_storage.name
    state_path     = local.state_path
    })

  condition_version                = "2.0"
  skip_service_principal_aad_check = true

  depends_on = [ azurerm_role_definition.backend_storage ] # custom RBAC
}
# Grant your personal user account access to view and manage the state files
# resource "azurerm_role_assignment" "user_storage_access" {
#   scope                = azurerm_storage_account.backend_storage.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azuread_client_config.current.object_id
# }