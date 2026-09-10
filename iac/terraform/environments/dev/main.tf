module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source                   = "../../modules/networking"
  vnet_name                = var.vnet_name
  location                 = var.location
  resource_group_name      = module.resource_group.name
  address_space            = var.vnet_address_space
  subnet_name              = var.subnet_name
  subnet_address_prefixes  = var.subnet_address_prefixes
  tags                     = var.tags
}

module "security" {
  source              = "../../modules/security"
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name
  security_rules      = var.security_rules
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = module.networking.subnet_id
  network_security_group_id = module.security.nsg_id
}

module "compute" {
  source               = "../../modules/compute"
  enabled              = var.compute_enabled
  name                 = var.compute_name
  location             = var.location
  resource_group_name  = module.resource_group.name
  subnet_id            = module.networking.subnet_id
  size                 = var.compute_size
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key
}

output "resource_group_name" { value = module.resource_group.name }
output "vnet_name" { value = module.networking.vnet_name }
output "utility_vm_private_ip" { value = module.compute.private_ip_address }
