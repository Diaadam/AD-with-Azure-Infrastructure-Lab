variable "enabled" {
     type    = bool
     description = "Whether to ssh."
     default = true
}

variable "name" {
     type = string
}

variable "location" {
     type = string
}

variable "resource_group_name" {
     type = string
}

variable "size" {
     type    = string
     default = "Standard_B1s"
}

variable "os_profile" {
     type    = object({
          computer_name  = optional(string)
          admin_username = string
          admin_password = string
          custom_data = optional(string)
     })
     default = {
    admin_username = "azureadmin"
    admin_password = "Password1234!"
  }
}

variable "ssh_public_key_path" {
     type    = string
     description = "path to the ssh-key.pub used to access the vm"
     default = ""
}
variable "src_img_ref" {
    type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
     })
  
    default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  }
variable "storage_os_disk" {
    type = object({
    name              = string
    caching           = string
    create_option     = string
    managed_disk_type = string
     })
  
    default = {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

variable "tags" {
  type = map(string)
}
###################################################
variable "network_interface_ids" {
  type = list(string)
}

variable "subnet_id" {
     type = string
}

####################
variable "public_ip" {
  type = string
  description = "{vm name}_pip"
}
variable "nic_name" {
  type = string
  description = "{vm name}_nic"
}
