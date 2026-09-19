# Compute OS Profile Configuration

## Why this was changed

The compute module supports both Linux and Windows virtual machine images. The AzureRM `azurerm_virtual_machine` resource must receive an OS-specific configuration block that matches the selected image.

The `terraform.tfvars` file selects a Windows Server image:

```hcl
src_img_ref = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-g2"
  version   = "latest"
}
```

The previous configuration always created `os_profile_linux_config`. Azure therefore received a Windows image together with a Linux configuration and returned:

```text
InvalidParameter: The value of parameter linuxConfiguration is invalid.
```

## Old configuration

The old code unconditionally created the Linux configuration block:

```hcl
os_profile_linux_config {
  disable_password_authentication = var.disable_password_authentication

  ssh_keys {
    key_data = file(var.ssh_public_key_path)
    path     = "/home/azureadmin/.ssh/authorized_keys"
  }
}
```

This works for Linux images, but it is invalid for Windows images because:

- Linux SSH settings are not valid Windows VM settings.
- The `linuxConfiguration` request property is sent to Azure even when the image is Windows.
- The SSH key path is a Linux path and does not apply to Windows.

## New configuration

The updated code uses Terraform `dynamic` blocks to create only the configuration appropriate for the image publisher:

```hcl
dynamic "os_profile_linux_config" {
  for_each = lower(var.src_img_ref.publisher) == "microsoftwindowsserver" ? [] : [1]

  content {
    disable_password_authentication = var.disable_password_authentication

    ssh_keys {
      key_data = file(var.ssh_public_key_path)
      path     = "/home/azureadmin/.ssh/authorized_keys"
    }
  }
}

dynamic "os_profile_windows_config" {
  for_each = lower(var.src_img_ref.publisher) == "microsoftwindowsserver" ? [1] : []

  content {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}
```

## How `for_each` controls the blocks

Terraform evaluates the condition using the image publisher:

| Image publisher | Linux block | Windows block |
|---|---:|---:|
| `MicrosoftWindowsServer` | `[]` - not created | `[1]` - created once |
| Any other publisher | `[1]` - created once | `[]` - not created |

An empty list means that Terraform creates zero instances of the dynamic block. A one-item list means that Terraform creates one instance. The value `1` is only a placeholder; the block contents are defined inside `content`.

The `lower()` function makes the comparison case-insensitive, so values such as `MicrosoftWindowsServer` and `microsoftwindowsserver` behave the same way.

## Result for this environment

Because this environment uses the `MicrosoftWindowsServer` publisher:

- `os_profile_linux_config` is omitted.
- `os_profile_windows_config` is included.
- Azure no longer receives the invalid `linuxConfiguration` property.
- The Windows VM agent is provisioned and automatic VM agent upgrades are enabled.

For a Linux image such as Canonical Ubuntu, the result is reversed: the Linux SSH configuration is included and the Windows configuration is omitted.

## Validation

From the development environment, run:

```powershell
terraform fmt -recursive
terraform validate
terraform plan
```

Review the plan to confirm that the VM configuration matches the selected image before applying changes.
