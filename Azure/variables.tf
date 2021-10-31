variable "region" {
  description = "Azure region to deploy to"
  type        = string
  default     = "East US"
}
variable "owner" {
  description = "Azure resource owner"
  type        = string
  default     = "bkauf@google.com"
}
variable "gcp_project" {
  description = "GCP project to register the Anthos Cluster To"
  type        = string 
  default     = "anthos-tech-summit"
}
variable "application_name" {
  description = "Azure Application Name. EX: Anthos-GKE"
  type        = string
  default     = "anthos-gke-test2"
}

variable "cluster_rg" {
  description = "Name for the Cluster Resource Group"
  type        = string
  default     = "bkauf-anthos-rg"
}
variable "vnet_name" {
  description = "Name of VNet to create"
  type        = string
  default     = "bkauf-anthos-vnet"
}
variable "vnet_resource_group" {
  description = "Azure VNet resouce group"
  type        = string
  default     = "bkauf-anthos-vnet-rg"
}

variable "role_admin" {
  description = "Name for the role admin"
  type        = string
  default     = "bkauf-anthos-role-admin"
}
variable "role_vnet_admin" {
  description = "Name for the VNet role admin"
  type        = string
  default     = "bkauf-anthos-vnet-admin"
}


#variable "ssh_pub_key" {
#  description = "ssh public key"
#  type        = string
#}

#variable "ssh_private_key_path" {
#  description = "path to the ssh private key"
#  type        = string
#}


