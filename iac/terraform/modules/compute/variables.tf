variable "enabled" { type = bool default = false }
variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "size" { type = string default = "Standard_B2s" }
variable "admin_username" { type = string default = "azureadmin" }
variable "admin_ssh_public_key" { type = string default = "" }
