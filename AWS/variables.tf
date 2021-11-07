
variable "anthos_prefix" {
  description = "Prefix to apply to Anthos AWS Policy & Network names"
  type        = string
  default     = "bkauf-new"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
    default     = "us-east-1"
}


variable "iam_role_path" {
  description = "The path for the IAM role"
  type        = string
  default     = "/"
}
variable "gcp_project" {
  description = "Name of the gcp project where the cluster will be registered."
  type = string
  default     = "anthos-tech-summit"
}
variable "gcp_project_number" {
  description = "Enter the project number of the gcp project where the cluster will be registered."
  type = string
  default     = "1046932852410"
}





variable "vpc_cidr_block" {
  description = "CIDR block to use for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in, 3 for contorl plane, 1 for node pools"
  type        = list(string)
  default     = [
    "us-east-1a",
    "us-east-1b", 
    "us-east-1c",
    "us-east-1a"
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

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks to use for private subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "public_subnet_cidr_block" {
  description = "CIDR Block to use for public subnet"
  type        = string
  default     = "10.0.101.0/24"
}

#variable "ssh_public_key" {
#  description = "SSH public key for logging into instances"
#  type        = string
#}

#variable "ssh_private_key_path" {
#  description = "Local file path to the SSH private key for logging into instances"
#  type        = string
#}



