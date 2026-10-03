# Compute Module

## Purpose

Creates an Ubuntu Linux virtual machine with a public IP address and network interface.

## Resources Created

- `random_password.vm_password`
- `azurerm_virtual_machine.this`
- `azurerm_public_ip.this`
- `azurerm_network_interface.this`

The VM uses the legacy `azurerm_virtual_machine` resource and supports SSH keys, optional password authentication, and Azure custom data.

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `suffix` | `string` | Required | Naming suffix used for the default computer name. |
| `disable_password_authentication` | `bool` | `true` | Disables VM password authentication when enabled. |
| `name` | `string` | Required | VM name. |
| `location` | `string` | Required | Azure region. |
| `resource_group_name` | `string` | Required | Resource group for the VM resources. |
| `size` | `string` | `Standard_B1s` | Azure VM size. |
| `os_profile` | object | `azureadmin` username | Admin username, optional password/computer name, and optional custom data. |
| `ssh_public_key_path` | `string` | `""` | Path to the SSH public key file. |
| `src_img_ref` | object | Ubuntu 22.04 Gen2 | Publisher, offer, SKU, and image version. |
| `storage_os_disk` | object | Standard LRS disk | OS disk name, caching, creation option, and managed disk type. |
| `subnet_id` | `string` | Required | Existing subnet ID for the network interface. |
| `public_ip` | `string` | Required | Public IP resource name. |
| `nic_name` | `string` | Required | Network interface resource name. |
| `tags` | `map(string)` | Required | Resource tags. |

## Outputs

- `vm_name`: Created VM name.
- `private_ip_address`: Private IP assigned to the NIC.
- `public_ip_address`: Public IP address.

## Dependencies and Notes

- The caller must provide an existing subnet ID and a readable SSH public-key file.
- Custom data must be formatted as expected by Azure; the dev environment base64-encodes its cloud-init templates before passing them here.
- If no admin password is supplied, a random password is generated.
- The generated password should be treated as sensitive.
