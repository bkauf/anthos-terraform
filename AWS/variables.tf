
variable "gcp_project" {
  description = "ID of the GCP project where the cluster will be registered."
  type        = string
}

# This variable is used to set up the default RBAC policy in your cluster for a Google 
# user so you can login after cluster creation.
variable "admin_user" {
  description = "User to get default Admin RBAC."
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

# You will need 3 AZs, one for each control plane node.
variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in. Node pool will be created in the first availability zone."
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}

# Use the following command to identify the correct AWS region for a given GCP location.
# gcloud container aws get-server-config --location {GCP_LOCATION}
variable "gcp_location" {
  description = "GCP location to deploy to."
  type        = string
  default     = "us-east4"
}

variable "vpc_cidr_block" {
  description = "CIDR block to use for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "cp_private_subnet_cidr_blocks" {
  description = "CIDR blocks to use for control plane private subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "np_private_subnet_cidr_blocks" {
  description = "CIDR block to use for node pool private subnets."
  type        = list(string)
  default = [
    "10.0.4.0/24"
  ]
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks to use for public subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable "pod_address_cidr_blocks" {
  description = "CIDR Block to use for pod subnet."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "service_address_cidr_blocks" {
  description = "CIDR Block to use for service subnet."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "node_pool_instance_type" {
  description = "AWS Node instance type."
  type        = string
  default     = "t3.medium"
}

variable "cluster_version" {
  description = "GKE version to install."
  type        = string
  default     = ""
}
