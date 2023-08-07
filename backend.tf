terraform {
  backend "azurerm" {
    resource_group_name   = "raj_rg"
    storage_account_name  = "yelati23"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"    
  }
}
