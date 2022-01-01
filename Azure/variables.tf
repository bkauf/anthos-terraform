variable "gcp_project_id" {
  description = "GCP project ID to register the Anthos Cluster to"
  type        = string
  default = "Enter GCP Project ID"
}
variable "azure_region" {
  description = "Azure region to deploy to"
  type        = string
  default     = "eastus"
}

variable "gcp_location" {
  description = "GCP region to deploy the multi-cloud API"
  type        = string
  default     = "us-east4"
}

variable "admin_user" {
  description = "GCP User to give admin RBAC to in the cluster"
  type        = string
  default     = "Enter Google Account email"
}

variable "cluster_version" {
  description = "GKE version to install"
  type        = string
  default     = "1.21.5-gke.2800"

}
