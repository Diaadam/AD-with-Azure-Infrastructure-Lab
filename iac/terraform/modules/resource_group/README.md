# Resource Group Module

## Purpose

Creates the shared Azure Resource Group used by the environment's other resources.

## Resources Created

- `azurerm_resource_group.this`

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | Required | Resource group name. |
| `location` | `string` | `UAE North` | Azure region. |
| `tags` | `map(string)` | `{}` | Resource group tags. |

## Outputs

- `name`: Resource group name.
- `location`: Resource group region.

## Dependencies and Notes

This module has no resource dependencies. Other modules normally consume its name and location outputs so all resources are deployed consistently.
