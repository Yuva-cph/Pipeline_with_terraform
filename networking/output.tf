output "vnet_interface_ids" {
    value = azurerm_network_interface.appnic.id
}
output "public_ip_address" {
    value = azurerm_public_ip.Linux_publicIP.ip_address
  
}