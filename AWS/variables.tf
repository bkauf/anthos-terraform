
variable "anthos_prefix" {
<<<<<<< HEAD
  description = "Prefix for all resource names"
=======
  description = "AWS Cluster name which will be a prefix to your Node, AWS Policy, & Network names"
  type        = string

}

variable "gcp_project_number" {
  description = "Enter the project number of the gcp project where the cluster will be registered."
  type        = string
}
variable "gcp_project_id" {
  description = "Enter the project id of the gcp project where the cluster will be registered."
>>>>>>> main
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
<<<<<<< HEAD
  default     = "us-east-2"
=======
  default     = "us-east-1"
>>>>>>> main
}

variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in, np will be created in the first"
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}

# Use the following command to identify the correct GCP location for a given AWS region
#gcloud container aws get-server-config --location [gcp-region]

variable "gcp_location" {
  description = "GCP location to deploy to"
  type        = string
  default     = "us-east4"
}

variable "iam_role_path" {
  description = "The path for the IAM role"
  type        = string
  default     = "/"
}

<<<<<<< HEAD
variable "gcp_project" {
  description = "Name of the gcp project where the cluster will be registered."
  type        = string
}
=======
>>>>>>> main

variable "vpc_cidr_block" {
  description = "CIDR block to use for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

<<<<<<< HEAD
variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in"
  type        = list(string)
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c",
  ]
}

=======
>>>>>>> main
variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks to use for public subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable "cp_private_subnet_cidr_blocks" {
  description = "CIDR blocks to use for control plane private subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "np_private_subnet_cidr_blocks" {
  description = "CIDR block to use for node pool private subnets"
  type        = list(string)
  default = [
    "10.0.4.0/24"
  ]
}


variable "public_subnet_cidr_block" {
  description = "CIDR Block to use for public subnet"
  type        = string
  default     = "10.0.101.0/24"
}

<<<<<<< HEAD
variable "admin_user" {
  description = "Admin user"
  type        = string
}

variable "cluster_version" {
  description = "Cluster version"
  type        = string
  default     = ""
}
=======

variable "pod_address_cidr_blocks" {
  description = "CIDR Block to use for pod subnet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "service_address_cidr_blocks" {
  description = "CIDR Block to use for service subnet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "node_pool_instance_type" {
  description = "AWS Node instance type"
  type        = string
  default     = "t3.medium"
}

variable "cluster_version" {
  description = "GKE version to install"
  type        = string
  default     = "1.21.5-gke.2800"

}





>>>>>>> main



