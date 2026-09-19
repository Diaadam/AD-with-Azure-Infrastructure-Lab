compute_name_ADC   = "adc"
compute_name_RODC  = "rodc"
compute_name_PDC   = "pdc"
compute_name_Child = "cairochild"

Dynamic_private_ip_address_alloc = false
private_ip_PDC                   = "10.1.2.20"
private_ip_ADC                   = "10.1.3.20"
private_ip_RODC                  = "10.1.4.20"
private_ip_Child                 = "10.1.5.20"

resource_group_name = "ad-multi-site-project"

compute_size_2 = "Standard_B1ms" # 1 vCPU, 2 GiB RAM  not free tier / within region vcpu quota
compute_size   = "Standard_B1ms"
# compute_size_2 = "Standard_B1s"

disable_password_authentication = false

os_profile = {
  computer_name  = "ad-multi-site-project"
  admin_username = "azureadmin"
  admin_password = "Tr0ubl3!M@k3r#99"
}

src_img_ref = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-g2"
  version   = "latest"
}

storage_os_disk = {
  name              = "ad-dc-osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
}
# compute_enabled          = false
# admin_ssh_public_key     = ""
# Public IPv4 address of the administrator PC allowed to use Bastion.
pc_public_ip_cidr = "156.207.240.164/32"
tags = {
  environment = "dev"
  project     = "ad-lab"
  managed_by  = "terraform"
}
rules = {
  allow_pc_to_bastion = {
    name                       = "allow-pc-to-bastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "1024-65535"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  allow_bastion_to_pc = {
    name                       = "allow-bastion-to-pc"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "1024-65535"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

Vnets = {
  "labVnet" = {
    vnet_name          = "labVnet"
    vnet_address_space = ["10.1.0.0/16"]
    subnets = {
      "AzureBastionSubnet" = {
        subnet_name             = "AzureBastionSubnet"
        subnet_address_prefixes = ["10.1.1.0/24"]
      }
      "PDC" = {
        subnet_name             = "PDC"
        subnet_address_prefixes = ["10.1.2.0/24"]
      }
      "ADC" = {
        subnet_name             = "ADC"
        subnet_address_prefixes = ["10.1.3.0/24"]
      }
      "RODC" = {
        subnet_name             = "RODC"
        subnet_address_prefixes = ["10.1.4.0/24"]
      }
      "NasrCityChild" = {
        subnet_name             = "NasrCityChild"
        subnet_address_prefixes = ["10.1.5.0/24"]
      }
    }
  }
}