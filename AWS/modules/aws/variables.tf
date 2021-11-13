variable "project_id" {
}
variable "location" {
  default = "us-west1"
}
variable "aws_region" {
  default = "us-west-2"
}
variable "cluster_version" {
  default = "1.19.10-gke.1000"
}
variable "database_encryption_kms_key_arn" {
}
variable "iam_instance_profile" {
}
variable "pod_address_cidr_blocks" {
  default = ["10.2.0.0/16"]
}
variable "service_address_cidr_blocks" {
  default = ["10.1.0.0/16"]
}
variable "admin_user" {
}
variable "vpc_id" {
}
variable "subnet_ids" {
}
variable "volume_kms_key_arn" {
  default = null
}
variable "role_arn" {
}
variable "node_pool_subnet_id" {
}
variable "fleet_project" {
}