output "vm-password" {
    value = azurerm_key_vault_secret.vmpassword.value
 
}
output "key_vault_id" {
    value = azurerm_key_vault.vault-webapp.id
  
}
output "clientsecret" {
    value = azurerm_key_vault_secret.clientsecret.value
 
}
/*output "clientid-value" {
    value = azurerm_key_vault_secret.clientid.value
 
}

output "tenantid-value" {
    value = azurerm_key_vault_secret.tenantid.value
 
}*/
