# Update the variables in the BACKEND block to refrence the 
# storage account created out of band for TF statemanagement.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.1"
    }

  }

backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstatelandingzone"
        container_name       = "tfstate"
        key                  = "AAD/terraform.tfstate"
    }

}

provider "azurerm" {
  features {}
}

provider "azuread" {
}
