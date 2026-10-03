# Security Module

## Purpose

Creates an Azure Network Security Group and a configurable set of network security rules.

## Resources Created

- `azurerm_network_security_group.this`
- `azurerm_network_security_rule.this`, one instance for each entry in `rules`

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `security_group_name` | `string` | Required | NSG name. |
| `location` | `string` | Required | Azure region. |
| `resource_group_name` | `string` | Required | Resource group for the NSG. |
| `rules` | `map(object)` | Required | Rule names, priorities, direction, access, protocol, ports, and address ranges. |
| `tags` | `map(string)` | `{}` | NSG tags. |

Rule port and address properties support either a single string or a list, depending on the Azure rule requirement.

## Outputs

- `nsg_id`: Created Network Security Group resource ID.

## Dependencies and Notes

- The caller must associate the NSG with a subnet or network interface.
- The current environment defaults allow-all inbound and outbound traffic. Replace these defaults with least-privilege rules before production use.
- Rule priorities must be unique within an NSG.
