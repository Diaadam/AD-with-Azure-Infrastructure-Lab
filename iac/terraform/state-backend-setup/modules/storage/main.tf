# Use random string to create naming suffix
resource "random_string" "backend_storage" {
  length  = 6
  special = false
  upper   = false
}
# data "azuread_client_config" "current" {}

locals {
  naming_string = "backendstorage${random_string.backend_storage.result}"
}

# Create resource group
resource "azurerm_resource_group" "backend_storage" {
  name     = local.naming_string
  location = "uaenorth"
  tags = var.tags
}

# Create storage account
resource "azurerm_storage_account" "backend_storage" {
  name                     = "tfstate${local.naming_string}"
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
    tags = var.tags
}



# Create containers in the storage account
resource "azurerm_storage_container" "backend_storage" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.backend_storage.id
  container_access_type = "private" # restrict public access (no anonymus)
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
