output "private_ip_address" {
  value = try(azurerm_network_interface.this[0].private_ip_address, null)
}
output "vm_name" {
  value = azurerm_virtual_machine.this.name
}