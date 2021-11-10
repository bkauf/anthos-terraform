output "aad_app_id" {
  description = "Azure application ID"
  value       = module.aad-app.aad_app_id
}

output "cluster_resource_group_id" {
  description = "The id of the cluster resource group"
  value       = module.cluster-rg.resource_group_id
}

output "vnet_id" {
  description = "The ID of the vnet"
  value       = module.cluster-vnet.vnet_id
}

output "vnet_location" {
  description = "The location/region of the vnet"
  value       = module.cluster-vnet.location
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.cluster-vnet.subnet_id
}

output "anthos_ssh_public_key" {
  description = "Anthos SSH public key"
  value       = tls_private_key.anthos-ssh-key.public_key_openssh
}
