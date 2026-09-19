module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source              = "../../modules/networking"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  for_each      = var.Vnets
  vnet_name     = each.value.vnet_name
  address_space = each.value.vnet_address_space
  subnets       = each.value.subnets
  tags          = var.tags
}

locals {
  active_directory_custom_data = base64encode(templatefile("../../scripts/customdata.tmp", {}))
  vm_os_profile                = merge(var.os_profile, { custom_data = local.active_directory_custom_data })
}



module "PDC" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_PDC
  location                         = var.location
  resource_group_name              = module.resource_group.name
  size                             = var.compute_size
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_PDC })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref
  storage_os_disk                  = var.storage_os_disk
  subnet_id                        = module.networking["labVnet"].subnet_ids["PDC"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_PDC
  # public_ip         = "${var.compute_name_PDC}pip"
  nic_name = "${var.compute_name_PDC}nic"
  tags     = var.tags
}
module "ADC" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_ADC
  location                         = var.location
  resource_group_name              = module.resource_group.name
  size                             = var.compute_size
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_ADC })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_ADC}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["ADC"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_ADC
  # public_ip         = "${var.compute_name_ADC}pip"
  nic_name = "${var.compute_name_ADC}nic"
  tags     = var.tags
}
module "RODC" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_RODC
  location                         = var.location
  resource_group_name              = module.resource_group.name
  size                             = var.compute_size_2
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_RODC })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_RODC}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["RODC"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_RODC
  # public_ip         = "${var.compute_name_RODC}pip"
  nic_name = "${var.compute_name_RODC}nic"
  tags     = var.tags
}
module "NasrCityChild" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_Child
  location                         = var.location
  resource_group_name              = module.resource_group.name
  size                             = var.compute_size_2
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_Child })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_Child}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["NasrCityChild"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_Child
  # public_ip         = "${var.compute_name_Child}pip"
  nic_name = "${var.compute_name_Child}nic"
  tags     = var.tags
}

################if custom data didnt work####################
resource "azurerm_virtual_machine_extension" "child_AD-Domain-srv_install_adds" {
  name                 = "install-adds-role"
  virtual_machine_id   = module.NasrCityChild.vm_id # Ensure this matches your VM resource name in the module
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"


  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools\""
    }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "PDC_AD_Domain_srv_install_adds" {
  name                 = "install-adds-role"
  virtual_machine_id   = module.PDC.vm_id # Ensure this matches your VM resource name in the module
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools\""
    }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "ADC_AD_Domain_srv_install_adds" {
  name                 = "install-adds-role"
  virtual_machine_id   = module.ADC.vm_id # Ensure this matches your VM resource name in the module
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools\""
    }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "RODC_AD_Domain_srv_install_adds" {
  name                 = "install-adds-role"
  virtual_machine_id   = module.RODC.vm_id # Ensure this matches your VM resource name in the module
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools\""
    }
  SETTINGS
}