
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
  network_interface_ids = var.network_interface_ids
  vm_size               = var.size
 delete_os_disk_on_termination = true



  storage_image_reference {
    publisher = var.src_img_ref.image_publisher
    offer     = var.src_img_ref.image_offer
    sku       = var.src_img_ref.image_sku
    version   = var.src_img_ref.image_version
  }
  
  storage_os_disk {
    name              = var.storage_os_disk.name             
    caching           = var.storage_os_disk.caching          
    create_option     = var.storage_os_disk.create_option    
    managed_disk_type = var.storage_os_disk.managed_disk_type
  }
  os_profile {
    computer_name  = try(var.os_profile.computer_name ,"azvm-${random_string.this}")
    admin_username = var.os_profile.admin_username
    admin_password = var.os_profile.admin_password
    custom_data    = var.os_profile.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = var.enabled

    ssh_keys {
      key_data = file("${ssh_public_key_path}")
      path     = "/home/testadmin/.ssh/authorized_keys"
    }
  }


  tags = var.tags
}
################################################

resource "azurerm_public_ip" "this" {
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
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id= azurerm_public_ip.this.id

  }
}