
variable "anthos_prefix" {
  description = "Prefix to apply to Anthos AWS Policy & Network names"
  type        = string
  default     = "bkauf-new"
}

#variable "aws_region" {
#  description = "AWS region to deploy to"
#  type        = string
#    default     = "us-east-1"
#}


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





#variable "vpc_cidr_block" {
#  description = "CIDR block to use for VPC"
#  type        = string
#  default     = "10.0.0.0/16"
#}

#variable "subnet_availability_zones" {
#  description = "Availability zones to create subnets in"
#  type        = list(string)
#  default     = []
#}

#variable "public_subnet_cidr_blocks" {
#  description = "CIDR blocks to use for public subnets"
#  type        = list(string)
#  default = [
#    "10.0.101.0/24",
#    "10.0.102.0/24",
#    "10.0.103.0/24"
#  ]
#}

#variable "private_subnet_cidr_blocks" {
#  description = "CIDR blocks to use for private subnets"
#  type        = list(string)
#  default = [
#    "10.0.1.0/24",
#    "10.0.2.0/24",
#    "10.0.3.0/24"
#  ]
#}

#variable "ssh_public_key" {
#  description = "SSH public key for logging into instances"
#  type        = string
#}

#variable "ssh_private_key_path" {
#  description = "Local file path to the SSH private key for logging into instances"
#  type        = string
#}



#variable "permissions_boundary" {
#  description = "The ARN of the policy that is used to set the permissions boundary for the role"
#  type        = string
#  default     = ""
#}

#variable "bastion_root_volume_kms_key_arn" {
#  description = "AWS Key Management Service (KMS) customer master key (CMK) to use for EBS encryption for the root filesystem of Bastion host"
#  type        = string
#  default     = ""
#}

#variable "extra_ssh_cidr_blocks" {
#  description = "CIDR blocks allowed for SSH access"
#  type        = list(string)
#  default = ["0.0.0.0/0"]
#}

#variable "create_proxy" {
#  description = "Whether or not a proxy should be instantiated and all traffic routed through it"
#  type        = bool
#  default     = false
#}

#variable "proxy_root_volume_kms_key_arn" {
#  description = "AWS Key Management Service (KMS) customer master key (CMK) to use for EBS encryption for the root filesystem of the proxy"
##  type        = string
#  default     = ""
#}

variable "gaia_service_account" {
  description = "Service account for AWS SDK web identity auth"
  type        = string
  default     = "cloud-gkemulticloud-test-guitar@system.gserviceaccount.com"
}



#variable "fleet_project" {
#  description = "Name of the Fleet host project where the cluster will be registered."
#  type = string
#}
