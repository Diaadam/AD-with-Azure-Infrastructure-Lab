resource "azurerm_network_security_group" "this" {
    name = var.security_group_name
    location = var.location
    tags = var.tags
    resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "this" {
    resource_group_name         = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.this.name
    for_each                    = var.rules
    name                        = each.value.name
    priority                    = each.value.priority
    direction                   = each.value.direction
    access                      = each.value.access
    protocol                    = each.value.protocol

    source_port_range            = try(each.value.source_port_range, null)
    source_port_ranges           = try(each.value.source_port_ranges, null)
    destination_port_range       = try(each.value.destination_port_range, null)
    destination_port_ranges      = try(each.value.destination_port_ranges, null)
    source_address_prefix        = try(each.value.source_address_prefix, null)
    source_address_prefixes      = try(each.value.source_address_prefixes, null)
    destination_address_prefix   = try(each.value.destination_address_prefix, null)
    destination_address_prefixes = try(each.value.destination_address_prefixes, null)


}


resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.this.id
}
