location                 = "eastus"
resource_group_name      = "rg-hybrid-ad-dev"
vnet_name                = "vnet-hybrid-ad-dev"
vnet_address_space       = ["10.20.0.0/16"]
subnet_name              = "snet-workload"
subnet_address_prefixes  = ["10.20.1.0/24"]
compute_enabled          = false
admin_ssh_public_key     = ""
tags = {
  environment = "dev"
  project     = "hybrid-ad-lab"
  managed_by  = "terraform"
}
security_rules = []
