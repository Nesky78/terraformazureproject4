terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateRGtomi"
    storage_account_name = "tfstate0123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}