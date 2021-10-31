

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

variable "name" {
  description = "Name for the Cluster Resource Group"
  type        = string
  default     = "bkauf-test-clusters"
}
variable "vnet_name" {
  description = "Name of VNet to create"
  type        = string
  default     = "bkauf-vnet-test"
}
variable "vnet_resource_group" {
  description = "Azure VNet resouce group"
  type        = string
  default     = "anthos-vnet-resource-group"
}

variable "role_admin" {
  description = "Name for the role admin"
  type        = string
  default     = "anthos-admin"
}
variable "role_vnet_admin" {
  description = "Name for the VNet role admin"
  type        = string
  default     = "anthos-vnet-admin"
}








#export AZURE_CLUSTER_1_POD_CIDR=10.1.0.0/16
#export AZURE_CLUSTER_1_SVC_CIDR=10.100.0.0/24






#variable "ssh_pub_key" {
#  description = "ssh public key"
#  type        = string
#}

#variable "ssh_private_key_path" {
#  description = "path to the ssh private key"
#  type        = string
#}

#variable "owner" {
#  description = "owner of the resources"
#  type        = string
#}

#variable "extra_ssh_cidr_blocks" {
#  description = "Allowed CIDRs for SSH"
#  type        = list(string)
#  # TODO(nsokolov): switch to narrowed down address space in Torpedo and get rid of /0
#  default = ["0.0.0.0/0"]
#}

#variable "service_account" {
#  description = "service account that should have access to gcp secrets"
#  type        = string
#}

#variable "create_proxy" {
#  description = "Whether or not a proxy instance and related resources should be created"
#  type        = bool
#  default     = false
#}

#variable "gcp_project" {
#  description = "gcp project for the secret manager secret"
#  type        = string
#}
#variable "fleet_project" {
#  description = "Name of the GCP project where the cluster will be registered."
#  type = string
#}


#variable "azure_application" {
#  description = "Name of the GCP project where the cluster will be registered."
#  type = string
#}