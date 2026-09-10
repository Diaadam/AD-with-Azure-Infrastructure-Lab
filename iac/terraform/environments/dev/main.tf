module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source                   = "../../modules/networking"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location

  for_each = var.Vnets
  vnet_name                = each.value.vnet_name
  address_space            = each.value.vnet_address_space
  subnets                  = each.value.subnets 
  tags                     = var.tags
}

module "security" {
  source              = "../../modules/security"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location

  security_group_name     = var.security_group_name
  rules               = var.rules
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = module.networking["vnet1"].subnet_ids["subnet_1"]
  network_security_group_id = module.security.nsg_id
}

module "compute" {
  source               = "../../modules/compute"
  disable_password_authentication              = var.disable_password_authentication
  name                 = var.compute_name
  location             = var.location
  resource_group_name  = module.resource_group.name
  size                 = var.compute_size
  os_profile           = var.os_profile
  ssh_public_key_path = var.ssh_public_key_path
  src_img_ref         = var.src_img_ref
  storage_os_disk    = var.storage_os_disk
  subnet_id         = module.networking["vnet1"].subnet_ids["subnet_1"]
  public_ip         = "${var.compute_name}pip"
  nic_name         = "${var.compute_name}nic"
  tags = var.tags
}

output "resource_group_name" { value = module.resource_group.name }
output "vnet_name" { value = module.networking["vnet1"].vnet_name }
output "vm_name" { value = module.compute.vm_name }
output "utility_vm_private_ip" { value = module.compute.private_ip_address }
