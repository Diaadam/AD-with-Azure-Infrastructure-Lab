resource "azurerm_linux_virtual_machine" "this" {
  count                 = var.enabled ? 1 : 0
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.this[0].id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.src_img_ref.publisher
    offer     = var.src_img_ref.offer
    sku       = var.src_img_ref.sku
    version   = var.src_img_ref.version
  }
}

resource "azurerm_network_interface" "this" {
  count               = var.enabled ? 1 : 0
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
