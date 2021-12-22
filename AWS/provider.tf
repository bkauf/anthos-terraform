terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 4.5.0"
    }
  }
}

provider "aws" {
  profile = "default"
<<<<<<< HEAD
  region  = var.aws_region
=======
  region  = "us-east-1"
>>>>>>> main
}
provider "google" {
  project = var.gcp_project
}
provider "google-beta" {
  project = var.gcp_project
}