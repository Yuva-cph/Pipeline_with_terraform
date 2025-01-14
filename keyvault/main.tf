resource "random_integer" "kv-suffix" {
    min = 5000
    max=100000
  
}
resource "random_password" "vmpwd" {
    length = 10
    min_lower = 1
    min_numeric = 1
    min_special = 1
    min_upper = 1
      
}

data "azurerm_client_config" "current" {
}
data "azuread_service_principal" "tfprincipal"{
    display_name = "terraform-app"
}

resource "azurerm_key_vault" "vault-webapp" {
    name = "vault${random_integer.kv-suffix.result}"
    location =var.location
    resource_group_name =var.resource_group_name
    sku_name ="standard" 
    tenant_id = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days =7
    purge_protection_enabled = false
    access_policy {
        tenant_id=data.azurerm_client_config.current.tenant_id
        object_id=data.azuread_service_principal.tfprincipal.object_id
    secret_permissions=["Get","Set","List","Delete"]
    key_permissions = ["Create","Import","Update","Delete","Get"]
    }
  
}
resource "azurerm_key_vault_secret" "vmpassword" {
    name="vmpassword"
    value = random_password.vmpwd.result
    key_vault_id = azurerm_key_vault.vault-webapp.id
    depends_on = [ azurerm_key_vault.vault-webapp ]
}
/*
resource "azurerm_key_vault_secret" "tenantid" {
    name="tenantid"
    value = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.vault-webapp.id
    depends_on = [ azurerm_key_vault.vault-webapp ]
}
resource "azurerm_key_vault_secret" "clientid" {
    name="clientid-tf"
    value = data.azurerm_client_config.current.client_id
    key_vault_id = azurerm_key_vault.vault-webapp.id
    depends_on = [ azurerm_key_vault.vault-webapp ]
}*/

resource "azurerm_key_vault_secret" "clientsecret" {
    name="clientsecret-tf"
    value = var.client-secret
    key_vault_id = azurerm_key_vault.vault-webapp.id
    depends_on = [ azurerm_key_vault.vault-webapp ]
}