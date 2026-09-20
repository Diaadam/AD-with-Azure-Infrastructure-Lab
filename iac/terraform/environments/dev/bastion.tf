data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}
locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}
module "nsg_azure_bastion" {
  source              = "../../modules/security"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  security_group_name = "bastion-nsg"
  tags                = var.tags

  rules = {
    allow_https_inbound = {
      name                       = "AllowHttpsInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = coalesce(local.my_ip, local.my_ip)
      destination_address_prefix = "*"
    }

    allow_gateway_manager = {
      name                       = "AllowGatewayManagerInbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }

    allow_bastion_inbound = {
      name                       = "AllowBastionHostCommunication"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    allow_load_balancer = {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }

    allow_ssh_rdp_outbound = {
      name                       = "AllowSshRdpOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    allow_azure_cloud = {
      name                       = "AllowAzureCloudOutbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }

    allow_bastion_outbound = {
      name                       = "AllowBastionCommunication"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    allow_http_outbound = {
      name                       = "AllowHttpOutbound"
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "azure_bastion" {
  subnet_id                 = module.networking["labVnet"].subnet_ids["AzureBastionSubnet"]
  network_security_group_id = module.nsg_azure_bastion.nsg_id

  depends_on = [module.nsg_azure_bastion]
}

resource "azurerm_public_ip" "bastion_host_pip" {
  name                = "bastion_host_pip"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "AzureBastionVM" {
  name                = "AzureBastionVM"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.networking["labVnet"].subnet_ids["AzureBastionSubnet"]
    public_ip_address_id = azurerm_public_ip.bastion_host_pip.id
  }
}
output "bastion_pip" {
  value = azurerm_public_ip.bastion_host_pip.ip_address
}