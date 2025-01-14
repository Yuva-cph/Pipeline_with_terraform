variable "resource_group_name" {
  type=string
  description = "name of the resource group name"
}
variable "location" {
  type = string
  description = "name of the location"
}
variable "client-secret" {
  type=string
  description = "client-secret"
  sensitive = true
}
