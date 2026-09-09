provider "azurerm" {
  features {}

  storage_use_azuread = true # because we are using ABAC 
}
