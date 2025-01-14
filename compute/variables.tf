variable "resource_group_name" {
  type=string
  description = "name of the resource group name"
}
variable "location" {
  type = string
  description = "name of the location"
}
variable "virtual_machine_name" {
    type = string
    description = "name of the linux virtual machine"
}
variable "vnet_interface_ids" {
    type = string
    description = "virtual network interface id"
  
}
variable "key_vault_id" {
    type = string
    description = "admin password gets from key vault as a secret value"
  
}
variable "public_ip_address" {
    type=string
    description = "public ip address get from the publicipaddress resources as output"
  
}
variable "client-secret" {
  type=string
  description = "client-secret"
  sensitive = true
}

variable "storage_account_name" {
  type = string
  description = "reference of storage account name from storage module"
  
}
variable "container_name" {
  type = string
  description = "reference of container name from storage module"
  
}