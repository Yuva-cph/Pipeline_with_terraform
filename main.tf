module "networking-module" {
    source = "./networking"
    location = var.location
    resource_group_name = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    virtual_network_address_space = var.virtual_network_address_space
    subnet_name = var.subnet_name
    subnet_address_prefix = var.subnet_address_prefix
    nsg_name = var.nsg_name
    security_rule = var.security_rule
    network_interface_name = var.network_interface_name
    public_ip_name = var.public_ip_name  
}
module "keyvault-module" {
    source = "./keyvault"
    location = var.location
    resource_group_name = var.resource_group_name
    client-secret = var.client_secret
    depends_on = [ module.networking-module ]
}
module "storage-module" {
    source = "./storage"
    location=var.location
    resource_group_name = var.resource_group_name
    depends_on = [ module.networking-module ]
}
module "compute-module" {
    source = "./compute"
    location = var.location
    resource_group_name = var.resource_group_name
    virtual_machine_name = var.virtual_machine_name
    key_vault_id = module.keyvault-module.key_vault_id
    public_ip_address = module.networking-module.public_ip_address
    vnet_interface_ids = module.networking-module.vnet_interface_ids
    client-secret = module.keyvault-module.clientsecret
    storage_account_name = module.storage-module.storage_account_name
    container_name = module.storage-module.container_name
  depends_on = [ 
    module.networking-module,
    module.keyvault-module,
    module.storage-module
   ]
}


