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
  zabbix_custom_data           = base64encode(file("../../scripts/zabbix-settup.yaml"))
  zabbix_os_profile            = merge(var.os_profile, { custom_data = local.zabbix_custom_data })
  zabbix_agent_version         = "7.0.26"
  zabbix_server_ip             = "10.1.7.20"
}



module "PDC" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_PDC
  location                         = module.resource_group.location
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
  location                         = module.resource_group.location
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
  location                         = module.resource_group.location
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
  name                             = var.compute_name_Child_1
  location                         = module.resource_group.location
  resource_group_name              = module.resource_group.name
  size                             = var.compute_size_2
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_Child_1 })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_Child_1}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["NasrCityChild"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_Child_1
  # public_ip         = "${var.compute_name_Child_1}pip"
  nic_name = "${var.compute_name_Child_1}nic"
  tags     = var.tags
}

module "GizaChild" {
  source                           = "../../modules/compute"
  disable_password_authentication  = var.disable_password_authentication
  name                             = var.compute_name_Child_2
  location                         = module.resource_group.location
  resource_group_name              = module.resource_group.name
  size                             = "Standard_A1_v2"
  os_profile                       = merge(local.vm_os_profile, { computer_name = var.compute_name_Child_2 })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = merge(var.src_img_ref, { sku = "2022-datacenter" })
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_Child_2}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["Giza"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_Child_2
  # public_ip         = "${var.compute_name_Child_2}pip"
  nic_name = "${var.compute_name_Child_2}nic"
  tags     = var.tags
}

module "zabbix_server" {
  source                           = "../../modules/compute"
  disable_password_authentication  = true
  name                             = var.compute_name_zabbix
  location                         = module.resource_group.location
  resource_group_name              = module.resource_group.name
  size                             = "Standard_A1_v2"
  os_profile                       = merge(local.zabbix_os_profile, { computer_name = var.compute_name_zabbix })
  ssh_public_key_path              = var.ssh_public_key_path
  src_img_ref                      = var.src_img_ref_zabbix
  storage_os_disk                  = merge(var.storage_os_disk, { name = "${var.compute_name_zabbix}-osdisk" })
  subnet_id                        = module.networking["labVnet"].subnet_ids["Zabbix"]
  Dynamic_private_ip_address_alloc = var.Dynamic_private_ip_address_alloc
  private_ip_address               = var.private_ip_zabbix
  # public_ip         = "${var.compute_name_zabbix}pip"
  nic_name   = "${var.compute_name_zabbix}nic"
  tags       = var.tags
  depends_on = [module.GizaChild]
}

#############################################################
module "nat_gateway" {
  source              = "../../modules/natgw"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
  name                = "lab-nat-gw"

  nat_subnets_ids = [
    module.networking["labVnet"].subnet_ids["PDC"],
    module.networking["labVnet"].subnet_ids["ADC"],
    module.networking["labVnet"].subnet_ids["RODC"],
    module.networking["labVnet"].subnet_ids["NasrCityChild"],
    module.networking["labVnet"].subnet_ids["Giza"],
    module.networking["labVnet"].subnet_ids["Zabbix"]
  ]
}
################if custom data didnt work####################
resource "azurerm_virtual_machine_run_command" "zabbix_agent_install" {
  for_each = {
    PDC           = module.PDC.vm_id
    ADC           = module.ADC.vm_id
    RODC          = module.RODC.vm_id
    NasrCityChild = module.NasrCityChild.vm_id
    GizaChild     = module.GizaChild.vm_id
  }

  name               = "install-zabbix-agent"
  virtual_machine_id = each.value
  location           = module.resource_group.location

  source {
    script = templatefile("${path.module}/../../scripts/install-zabbix-agent.ps1", {
      zabbix_agent_version = local.zabbix_agent_version
      zabbix_server_ip     = local.zabbix_server_ip
    })
  }
}

resource "azurerm_virtual_machine_run_command" "ad_domain_srv_install_adds" {
  for_each = {
    PDC           = module.PDC.vm_id
    ADC           = module.ADC.vm_id
    RODC          = module.RODC.vm_id
    NasrCityChild = module.NasrCityChild.vm_id
    GizaChild     = module.GizaChild.vm_id
  }

  name               = "install-adds-role"
  virtual_machine_id = each.value
  location           = module.resource_group.location

  source {
    script = "Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools"
  }
}
