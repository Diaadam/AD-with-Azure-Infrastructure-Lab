# Terraform Init OIDC Authentication Error

## Error

Terraform fails during backend and module initialization with:

```text
Initializing the backend...
Initializing modules...

Error: Error building ARM Config: 2 errors occurred:
  * a Tenant ID must be configured when authenticating with OIDC
  * a Client ID must be configured when authenticating with OIDC
```

## Cause

The AzureRM backend is configured to use OpenID Connect (OIDC):

```hcl
backend "azurerm" {
  use_oidc         = true
  use_azuread_auth = true
}
```

The `azure/login` GitHub Action authenticates the Azure CLI, but Terraform also needs its own AzureRM authentication environment variables.

> The workflow authenticates Azure CLI with azure/login, while Terraform independently authenticates through AzureRM using the ARM_* environment variables. The two tools use separate authentication clients, even though they can use the same OIDC identity. 

## Required GitHub Actions Environment Variables

The Terraform job must export:

```yaml
env:
  ARM_USE_OIDC: "true"
  ARM_USE_AZUREAD: "true"
  ARM_CLIENT_ID: ${{ vars.OIDC_CLIENT_ID }}
  ARM_TENANT_ID: ${{ vars.TENANT_ID }}
  ARM_SUBSCRIPTION_ID: ${{ vars.SUBSCRIPTION_ID }}
```

These variables must be available to every step that runs `terraform init`, `terraform plan`, or `terraform apply`.

## GitHub Environment Configuration

Configure these variables in the GitHub Environment used by the workflow, such as `dev`:

| Variable | Description |
| --- | --- |
| `OIDC_CLIENT_ID` | Microsoft Entra application or service principal client ID |
| `TENANT_ID` | Microsoft Entra tenant ID |
| `SUBSCRIPTION_ID` | Azure subscription ID |

The service principal must also have a federated credential matching the repository, workflow, branch or tag, and GitHub Environment used by the job.

## Validation

Run Terraform from the selected environment directory:

```bash
terraform init \
  -backend-config="resource_group_name=<storage-resource-group>" \
  -backend-config="storage_account_name=<storage-account>" \
  -backend-config="container_name=<container>" \
  -backend-config="key=<state-key>"
```

Then validate the configuration:

```bash
terraform validate
```
