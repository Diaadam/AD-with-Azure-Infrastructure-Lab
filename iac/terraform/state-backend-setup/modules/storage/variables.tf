variable "tags" {
  type = map(string)

  default = {
    environment = "dev"
  }
}
variable "location" {
  type = string
  default = "uaenorth"
}
variable "container_name" {
  type    = string
  default = "tfstate"
}
