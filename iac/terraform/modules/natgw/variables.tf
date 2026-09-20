variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "nat_subnets_ids" {
  # We exclude AzureBastionSubnet from this list intentionally
  type = list(string)
}