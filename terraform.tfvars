resource_group_name = "<your-rg-name>"
location = "<your-location>"
virtual_network_name = "<your-network-name>"
virtual_network_address_space = "10.0.0.0/16"
subnet_name = "<your-subnet-name>"
subnet_address_prefix = "10.0.0.0/24"
nsg_name = "<your-nsg-name>"
network_interface_name = "<your-nic-name>"
virtual_machine_name = "<your-vm-name>"
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
    public_ip_name = "<your-ip-name>"

  
