variable "project_number" {
}
variable "location" {
  default = "us-west1"
}
variable "azure_region" {
  default = "westus2"
}
variable "resource_group_id" {
}
variable "admin_user" {
}
variable "cluster_version" {
  default = "1.21.5-gke.2800"
}
variable "subnet_id" {

}
variable "ssh_public_key" {

}
variable "virtual_network_id" {

}
variable "pod_address_cidr_blocks" {
  default = ["10.200.0.0/16"]
}
variable "service_address_cidr_blocks" {
  default = ["10.32.0.0/24"]
}
variable "anthos_prefix" {

}
variable "tenant_id" {

}
variable "application_id" {

}
variable "application_object_id" {

}
variable "fleet_project" {

}