variable "gcp_project" {
  description = "GCP project to register the Anthos Cluster To"
  type        = string
}
variable "gcp_location" {
  description = "GCP location to deploy the multi-cloud API"
  type        = string
  default     = "us-west1"
}
variable "azure_region" {
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
variable "cluster_version" {
  description = "Cluster version"
  type        = string
  default     = "1.21.5-gke.2800"
}



