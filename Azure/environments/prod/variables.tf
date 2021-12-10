variable "region" {
  description = "Azure region to deploy to"
  type        = string
  default     = "east us"
}


variable "azure_cluster" {
  description = "Name for the Anthos on Azure cluster, this will be the prefix for all artifacts created"
  type        = string
 
}


variable "gcp_project_id" {
  description = "GCP project ID to register the Anthos Cluster to"
  type        = string

}

variable "gcp_region" {
  description = "GCP region to deploy the multi-cloud API"
  type        = string
  default     = "us-east4"
}

variable "gcp_azure_location" {
  description = "Azure region depiction in GCP. For example East US is eastus2"
  type        = string
  default     = "eastus"
}

#variable "application_name" {
#  description = "Azure Application Name for IAM. EX: Anthos-GKE"
#  type        = string
#  default     = "gcp-anthos"
 
#}

#variable "azure_client" {
#  description = "Name for the GCP Azure client"
#  type        = string
#  default     = "gcp-anthos"
#}


#variable "cluster_rg" {
#  description = "Name for the Cluster Resource Group"
#  type        = string
#  default     = "anthos-gke"
#}
#variable "vnet_name" {
#  description = "Name of VNet to create"
#  type        = string
#  default     = "anthos-gke"
#}
#variable "vnet_resource_group" {
#  description = "Azure VNet resouce group"
#  type        = string
#  default     = "anthos-vnet"
#}



