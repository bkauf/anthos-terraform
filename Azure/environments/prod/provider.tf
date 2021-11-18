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
provider "google" {
  project                         = var.gcp_project
  container_azure_custom_endpoint = "https://us-west1-preprod-gkemulticloud.sandbox.googleapis.com/v1/"
}
provider "google-beta" {
  project = var.gcp_project
}