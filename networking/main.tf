#creation of suffix for the public ip name
resource "random_integer" "ipnamesuffix" {
  min = 3000
  max = 8000
}

#creation of Azure Resource group
resource "azurerm_resource_group" "hostgrp" {
  name = var.resource_group_name
  location = var.location
}
#creation of Azure virtual network
resource "azurerm_virtual_network" "appnetwork" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.hostgrp.location
  resource_group_name = azurerm_resource_group.hostgrp.name
  address_space       = [var.virtual_network_address_space]
  depends_on = [ azurerm_resource_group.hostgrp ]
}
#creation of azure subnet
resource "azurerm_subnet" "appsubnet" {
    name=var.subnet_name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    address_prefixes = [var.subnet_address_prefix]
depends_on = [ azurerm_virtual_network.appnetwork ]
  
}

#creation of azure network security group with security rules
resource "azurerm_network_security_group" "nsg" {
   name                = var.nsg_name
  location            = azurerm_resource_group.hostgrp.location
  resource_group_name = azurerm_resource_group.hostgrp.name
  dynamic "security_rule" {
    for_each = var.security_rule
    content {
      name = security_rule.value["name"]
      priority=security_rule.value["priority"]
  direction="Inbound"
  access=security_rule.value["access"]
  protocol="Tcp"
  source_port_range           = "*"
  destination_port_range      = security_rule.value["destination_port_range"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
    }
    
  }
  depends_on = [ azurerm_resource_group.hostgrp ]
}

#associating network security group with the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_subnet_link" {
  subnet_id = azurerm_subnet.appsubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [ azurerm_subnet.appsubnet,
  azurerm_network_security_group.nsg ]
}

#creation of public IP address
resource "azurerm_public_ip" "Linux_publicIP" {
  name = "${var.public_ip_name}${random_integer.ipnamesuffix.result}"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  domain_name_label = "apacheserverusingpip${random_integer.ipnamesuffix.result}"
  depends_on = [ azurerm_resource_group.hostgrp ]
}

#creation of network interface 
resource "azurerm_network_interface" "appnic" {
    name = var.network_interface_name
    resource_group_name = var.resource_group_name
    location = var.location
    ip_configuration {
      name = "internal"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.appsubnet.id
      public_ip_address_id=azurerm_public_ip.Linux_publicIP.id
    }
    depends_on = [azurerm_resource_group.hostgrp,
    azurerm_subnet.appsubnet,
    azurerm_public_ip.Linux_publicIP ]  
}
