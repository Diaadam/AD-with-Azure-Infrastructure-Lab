output "resource_group_name" { value = module.resource_group.name }
output "vnet_name" { value = module.networking["labVnet"].vnet_name }

output "PDC_name" { value = module.PDC.vm_name }
output "PDC_private_ip" { value = module.PDC.private_ip_address }
output "PDC_public_ip" { value = var.no_pip ? null : module.PDC.public_ip_address }

output "ADC_name" { value = module.ADC.vm_name }
output "ADC_private_ip" { value = module.ADC.private_ip_address }
output "ADC_public_ip" { value = var.no_pip ? null : module.ADC.public_ip_address }

output "RODC_name" { value = module.RODC.vm_name }
output "RODC_private_ip" { value = module.RODC.private_ip_address }
output "RODC_public_ip" { value = var.no_pip ? null : module.RODC.public_ip_address }

output "NasrCityChild_name" { value = module.NasrCityChild.vm_name }
output "NasrCityChild_private_ip" { value = module.NasrCityChild.private_ip_address }
output "NasrCityChild_public_ip" { value = var.no_pip ? null : module.NasrCityChild.public_ip_address }

output "Giza_name" { value = module.GizaChild.vm_name }
output "GizaChild_private_ip" { value = module.GizaChild.private_ip_address }
output "GizaChild_public_ip" { value = var.no_pip ? null : module.GizaChild.public_ip_address }

output "zabbix_name" { value = module.zabbix_server.vm_name }
output "zabbix_private_ip" { value = module.zabbix_server.private_ip_address }
output "zabbix_public_ip" { value = var.no_pip ? null : module.zabbix_server.public_ip_address }



