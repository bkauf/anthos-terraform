
variable "anthos_prefix" {
  description = "AWS Cluster name which will be a prefix to your Node, AWS Policy, & Network names"
  type        = string

}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "gcp_location" {
  description = "GCP region to deploy to"
  type        = string
  default     = "us-east4"
}

variable "iam_role_path" {
  description = "The path for the IAM role"
  type        = string
  default     = "/"
}

variable "gcp_project" {
  description = "Name of the gcp project where the cluster will be registered."
  type        = string
 
}

variable "gcp_project_number" {
  description = "Enter the project number of the gcp project where the cluster will be registered."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block to use for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in, 3 for contorl plane, 1 for node pools"
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}

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





