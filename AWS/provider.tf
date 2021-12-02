provider "aws" {
  profile = "default"
  region  = var.aws_region
}
provider "google" {
  project                       = var.gcp_project
  container_aws_custom_endpoint = var.endpoint
}
provider "google-beta" {
  project = var.gcp_project
}