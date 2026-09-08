# Backend settings are shared as documentation. Each environment may override the
# state key during `terraform init` with -backend-config values.
terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
}
