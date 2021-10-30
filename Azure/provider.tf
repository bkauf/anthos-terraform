terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
   
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  #version = "=2.44.0"
  features {}
}

provider "azuread" {
#  version = "=1.6.0"
}
