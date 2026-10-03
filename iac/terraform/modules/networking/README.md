# Networking Module

## Purpose

Creates an Azure Virtual Network and a configurable collection of subnets.

## Resources Created

- `azurerm_virtual_network.this`
- `azurerm_subnet.this`, one instance for each entry in `subnets`

Subnet delegation blocks are generated when delegation definitions are supplied.

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `vnet_name` | `string` | Required | Virtual Network name. |
| `location` | `string` | Required | Azure region. |
| `resource_group_name` | `string` | Required | Resource group for the network resources. |
| `address_space` | `list(string)` | Required | VNet address ranges. |
| `subnets` | `map(object)` | Required | Subnet names, address prefixes, optional service endpoints, and optional delegations. |
| `tags` | `map(string)` | `{}` | Resource tags. |

## Outputs

- `vnet_name`: Created VNet name.
- `vnet_id`: Created VNet resource ID.
- `subnet_ids`: Map from the caller's subnet keys to subnet IDs.

## Dependencies and Notes

- The module does not create NSGs or associate them with subnets; use the security module and an association resource separately.
- Optional subnet delegation values are safely treated as an empty list when omitted.
- `service_endpoints` is accepted by the variable schema but is not currently applied to the `azurerm_subnet` resource.
- Subnet keys are part of the module output contract and should remain stable.
