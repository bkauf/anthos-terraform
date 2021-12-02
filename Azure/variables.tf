variable "owner" {
  description = "Azure resource owner"
  type        = string
}
variable "gcp_project" {
  description = "GCP project to register the Anthos Cluster To"
  type        = string
}
variable "gcp_project_number" {
  description = "GCP project number to register the Anthos Cluster To"
  type        = string
}
variable "gcp_location" {
  description = "GCP region to deploy the multi-cloud API"
  type        = string
  default     = "us-west1"
}
variable "region" {
  description = "Azure region to deploy to"
  type        = string
  default     = "westus2"
}
variable "anthos_prefix" {
  type = string
}
variable "admin_user" {
  description = "Admin user"
  type        = string
}
variable "endpoint" {
}


