output "vnet_name" {
     value = azurerm_virtual_network.this.name
      }

# output "subnet_id" {
#      value = azurerm_subnet.this.id
#       }

output "subnet_ids" {
  value = {
    for subnet_key, subnet in azurerm_subnet.this :
    subnet_key => subnet.id
  }
}

# {
#   vnet1 = {
#     subnet_1 = "/subscriptions/.../subnets/test"
#   }
# }