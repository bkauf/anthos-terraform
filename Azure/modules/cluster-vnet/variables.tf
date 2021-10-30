variable "name" {
  description = "Name for the test cluster"
  type        = string
}

variable "region" {
  description = "Azure region to deploy to"
  type        = string
  default     = "East US"
}

variable "aad_app_name" {
  description = "app registration name"
  type        = string
}
variable "sp_obj_id" {
  description = "app service principal object id"
  type        = string
}
variable "vnet_resource_group" {
  description = "Azure VNet resouce group"
  type        = string
}
variable "subscription_id" {
  description = "subscription_id "
  type = string
}