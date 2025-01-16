
#variables defined in pipeline
/*variable "bkstrRgp"{
  type=string
  description="backend state file resource group name"
}
variable "bkstrsa"{
  type=string
  description="backend state file storage account name"
}
variable "bkcontainer"{
  type=string
  description="backend state file container name"
}
variable "bkkey"{
  type=string
  description="backend state file blob name"
}*/


#variables defined in terraform code
variable "resource_group_name" {
  type=string
  description = "name of the resource group name"
}
variable "location" {
  type = string
  description = "name of the location"
}
variable "virtual_network_name" {
    type=string
    description = "name of the virtual network"
}
variable "virtual_network_address_space" {
    type=string
    description = "describes the virtual network address space"
}
variable "subnet_name" {
    type=string
    description = "name of the subnet"
}
variable "subnet_address_prefix" {
    type=string
    description = "describes the subnet address prefix"
}

variable "nsg_name" {
  type=string
  description = "the name of network security group"
}

variable "security_rule" {
    description = "defines the list of security rules"
    type=list(object({
        name                       = string
    priority                   = number
    access                     = string
    destination_port_range     = string
    
    }))
}
variable "public_ip_name" {
    type=string
    description = "the name of the public ip address"  
}
variable "network_interface_name" {
    type = string
    description = "the name of the network interface"
  
}
variable "virtual_machine_name" {
    type = string
    description = "name of the linux virtual machine"
}


variable "client_secret" {
  type=string
  description = "client-secret"
  sensitive = true
}


