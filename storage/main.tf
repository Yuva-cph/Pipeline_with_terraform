resource "random_integer" "sanamesuffix" {
  min=456655
  max=700000
  
}
resource "azurerm_storage_account" "backupstorage" {
    name = "webappbackup${random_integer.sanamesuffix.result}"
    location = var.location
    resource_group_name = var.resource_group_name
    account_tier = "Standard"
    account_replication_type = "LRS"
}

#creation of the container to store webapp backup
resource "azurerm_storage_container" "backup" {
  name ="backup"
  storage_account_id = azurerm_storage_account.backupstorage.id
  depends_on = [ azurerm_storage_account.backupstorage ]
}


