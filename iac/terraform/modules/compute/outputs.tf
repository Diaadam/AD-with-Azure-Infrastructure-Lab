output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  value = var.no_pip ? null : azurerm_public_ip.this[0].ip_address
}
output "vm_name" {
  value = azurerm_virtual_machine.this.name
}
output "vm_id" {
  value = azurerm_virtual_machine.this.id
}