resource_group_name = "rg-lapa-webapp"
location = "Central India"
virtual_network_name = "vnet-webapp"
virtual_network_address_space = "10.0.0.0/16"
subnet_name = "sub-webapp"
subnet_address_prefix = "10.0.0.0/24"
nsg_name = "nsg-webapp"
network_interface_name = "nic-webapp"
virtual_machine_name = "Apache-webapp"
security_rule = [ {
      name                       = "AllowSSH"
    priority                   = 300
    access                     = "Allow"
    destination_port_range     = "22"
    },
    {
      name                       = "AllowHTTPS"
    priority                   = 310
    access                     = "Allow"
    destination_port_range     = "443"
    },
    {
      name                       = "AllowHTTP"
    priority                   = 320
    access                     = "Allow"
    destination_port_range     = "80"
    } ]
    public_ip_name = "pipe-serverip"

  
