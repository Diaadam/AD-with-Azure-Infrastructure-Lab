variable "enabled" {
     type    = bool
     description = "Whether to enable the compute resources."
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

variable "subnet_id" {
     type = string
}

variable "size" {
     type    = string
     default = "Standard_B2s"
}

variable "admin_username" {
     type    = string
     default = "azureadmin"
}

variable "admin_ssh_public_key" {
     type    = string
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