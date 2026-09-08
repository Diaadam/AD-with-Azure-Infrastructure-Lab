# Enterprise Hybrid AD with Azure Infrastructure Lab

A repeatable Azure lab for designing and validating hybrid Active Directory infrastructure with Terraform. The repository keeps infrastructure code, operational notes, and CI/CD definitions together.

## Definition of done

- Terraform is formatted and validates for each environment.
- A resource group, virtual network, subnet, NSG, and optional Linux utility VM can be planned from Terraform.
- Remote state configuration is documented and can be enabled without changing module code.
- Architecture decisions and troubleshooting history are recorded.
- CI runs formatting, validation, and security checks on pull requests.
- CD publishes an artifact and records the intended GitOps tag update.

## Repository layout

- `docs/architecture.md` - design decisions and system diagram.
- `troubleshooting.md` - issue log and fixes.
- `iac/terraform/modules` - reusable Terraform modules.
- `iac/terraform/environments` - environment-specific composition and values.
- `.github/workflows` - CI and CD automation.

## Prerequisites

- Terraform >= 1.6
- Azure CLI >= 2.50
- An authenticated Azure subscription
- GNU Make, or equivalent commands from the `Makefile`

## Quick start

```bash
az login
az account set --subscription <subscription-id>
make init ENV=dev
make validate ENV=dev
make plan ENV=dev
```

Apply only after reviewing the plan:

```bash
make apply ENV=dev
```

The default configuration creates a lab resource group and network. The compute module is disabled by default until an SSH public key is supplied.

## State

The checked-in `backend.tf` documents the Azure Storage remote backend. Supply backend configuration at initialization time, for example:

```bash
terraform -chdir=iac/terraform/environments/dev init \
  -backend-config="resource_group_name=<state-resource-group>" \
  -backend-config="storage_account_name=<state-storage-account>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=hybrid-ad/dev.tfstate"
```

Do not commit credentials, state files, plans, or SSH private keys.

## Common commands

```bash
make fmt
make validate ENV=dev
make plan ENV=dev
make apply ENV=dev
make destroy ENV=dev
make lint
make test
```

This is a lab scaffold: domain controller promotion, DNS conditional forwarding, VPN/ExpressRoute, monitoring, and production policies are intentionally documented as follow-up work rather than silently implied by the base network.
