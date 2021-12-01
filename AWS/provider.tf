provider "aws" {
  profile = "default"
  region  = "us-west-2"
}
provider "google" {
  project                       = var.gcp_project
  container_aws_custom_endpoint = "https://us-west1-gkemulticloud.googleapis.com/v1/"
}
provider "google-beta" {
  project = var.gcp_project
}