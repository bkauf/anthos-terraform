provider "aws" {
  profile = "default"
  region  = var.aws_region
}
provider "google" {
  project = var.gcp_project
}
provider "google-beta" {
  project = var.gcp_project
}