
# Use random string to create naming suffix
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_virtual_machine" "this" {
  name                  = var.name                 
  location              = var.location             
  resource_group_name   = var.resource_group_name  
  network_interface_ids = [azurerm_network_interface.this.id]
  vm_size               = var.size
 delete_os_disk_on_termination = true



  storage_image_reference {
    publisher = var.src_img_ref.publisher
    offer     = var.src_img_ref.offer
    sku       = var.src_img_ref.sku
    version   = var.src_img_ref.version
  }
  
  storage_os_disk {
    name              = var.storage_os_disk.name             
    caching           = var.storage_os_disk.caching          
    create_option     = var.storage_os_disk.create_option    
    managed_disk_type = var.storage_os_disk.managed_disk_type
  }
  os_profile {
  computer_name = coalesce(var.os_profile.computer_name,"azvm-${random_string.this.result}")
    admin_username = var.os_profile.admin_username
    admin_password = var.os_profile.admin_password
    custom_data    = var.os_profile.custom_data
  }

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


  tags = var.tags
}
################################################

resource "azurerm_public_ip" "this" {
  count = var.no_pip == true ? 0:1
  name                = var.public_ip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.Dynamic_private_ip_address_alloc ? "Dynamic" : "Static"
    private_ip_address            = var.Dynamic_private_ip_address_alloc ? null : var.private_ip_address
    public_ip_address_id= var.no_pip == true ? null : azurerm_public_ip.this[0].id # count turned `this` into a list

  }
}