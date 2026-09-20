###resource group
variable "resource_group_name" {
  type        = string
  description = "Resource group name."
  default     = "test"
}
# ["uaenorth","switzerlandnorth","spaincentral","italynorth","polandcentral"]
variable "location" {
  type        = string
  description = "Azure region."
  default     = "UAE North"
}
# variable "location2" {
#   type        = string
#   description = "Azure region."
#   default     = "italynorth"
# }

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default = {
    env = "test"
  }
}

########networking#####

variable "Vnets" {
  type = map(
    object({
      vnet_name          = string
      vnet_address_space = list(string)
      subnets = map(object({
        subnet_name = string
      subnet_address_prefixes = list(string) }))
    })
  )

  default = {
    "vnet1" = {
      vnet_name          = "test"
      vnet_address_space = ["10.1.0.0/16"]
      subnets = {
        "AzureBastionSubnet" = {
          subnet_name             = "AzureBastionSubnet"
          subnet_address_prefixes = ["10.1.1.0/24"]
        }
        "subnet_1" = {
          subnet_name             = "subnet_1"
          subnet_address_prefixes = ["10.1.2.0/24"]
      } }
    }
  }
}
#############
variable "no_pip" {
  type    = bool
  default = false
}
variable "security_group_name" {
  type    = string
  default = "nsg"
}

variable "pc_public_ip_cidr" {
  type        = string
  description = "Public IP CIDR allowed to access Azure Bastion."
  default     = null
}

variable "rules" {
  type = map(object({
    name      = string
    priority  = number
    direction = string
    access    = string
    protocol  = string
    # Using optional() allows you to omit these in the variable default
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = {
    allow_all_inbound = {
      name                       = "allow-all-inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    allow_all_outbound = {
      name                       = "allow-all-outbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
#######################
variable "disable_password_authentication" {
  type        = bool
  description = "true to ssh."
  default     = true
}


variable "compute_size" {
  type    = string
  default = "Standard_B1s"
}
variable "compute_size_2" {
  type    = string
  default = "Standard_B1s"
}

variable "os_profile" {
  type = object({
    computer_name  = optional(string)
    admin_username = string
    admin_password = string
    custom_data    = optional(string)
  })
  default = {
    admin_username = "azureadmin"
    admin_password = "Password1234!"
  }
}

variable "ssh_public_key_path" {
  type        = string
  description = "path to the ssh-key.pub used to access the vm"
  default     = "ssh-key.pub"
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

variable "src_img_ref_zabbix" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

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

variable "Dynamic_private_ip_address_alloc" {
  type = bool

}
variable "private_ip_PDC" {
  type = string
}
variable "private_ip_ADC" {
  type = string
}
variable "private_ip_RODC" {
  type = string
}
variable "private_ip_Child_1" {
  type = string
}
variable "private_ip_Child_2" {
  type = string
}
variable "private_ip_zabbix" {
  type = string
}


variable "compute_name_ADC" {
  type = string

}
variable "compute_name_RODC" {
  type = string

}
variable "compute_name_Child_1" {
  type = string

}
variable "compute_name_Child_2" {
  type = string

}
variable "compute_name_PDC" {
  type = string

}
variable "compute_name_zabbix" {
  type = string

}

###################################################
####################


