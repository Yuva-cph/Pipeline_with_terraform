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
    resource_group_name="tfstate-grp"
    storage_account_name="tfstategroup2025"
    container_name="statefile6"
    key="testterraform.tfstate"
}

}
provider "azuread" {
  
}

provider "azurerm" {
    features {}
  
}
