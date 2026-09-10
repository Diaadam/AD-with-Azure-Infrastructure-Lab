output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.this.ip_address
}

output "vm_name" {
  value = azurerm_virtual_machine.this.name
}