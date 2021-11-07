variable "vpc_cidr_block" {
  description = "CIDR block to use for VPC"
  type        = string
}
variable "aws_region" {
  description = "AWS Region to use for VPC"
  type        = string
}

variable "anthos_prefix" {
  description = "Anthos naming prefix"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks to use for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks to use for private subnets"
  type        = list(string)
  default     = []
}

variable "subnet_availability_zones" {
  description = "Availability zones to create subnets in"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidr_block" {
  description = "CIDR blcok to use for public subnet"
  type        = string
}
