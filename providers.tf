terraform {
    required_providers {
       azurerm = {
      source = "hashicorp/azurerm"
      version = "4.14.0"
    }
     azuread = {
      source = "hashicorp/azuread"
      version = "3.0.2"
    }
    }
backend "azurerm"{
    resource_group_name= var.bkstrRgp
    storage_account_name= var.bkstrsa
    container_name= var.bkcontainer
    key=var.bkkey
}

}
provider "azuread" {
  
}

provider "azurerm" {
    features {}
  
}
