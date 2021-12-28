output "cluster_name" {
  description = "The automatically generated name of your aws GKE cluster"
  value       = local.name_prefix
}
output "project_id" {
  description = "ID of the GCP project where the cluster is managed."
  value       = var.gcp_project
}
output "project_number" {
  description = "Number of the GCP project where the cluster is managed."
  value       = module.gcp_data.project_number
}
output "gcp_location" {
  description = "GCP location where the cluster is managed."
  value       = var.gcp_location
}
output "aws_region" {
  description = "AWS region where the cluster is deployed to."
  value       = module.anthos_cluster.aws_region
}
output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.aws_vpc_id
}
output "subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.anthos_cluster.subnet_ids
}
output "message" {
  description = "Connect Instructions"
  value       = "To connect to your cluster issue the command: gcloud container hub memberships get-credentials ${local.name_prefix}"
}
output "cluster_version" {
  description = "Kubernetes version."
  value       = coalesce(var.cluster_version, module.gcp_data.latest_version)
}
output "encryption_kms_key_arn" {
  description = "KMS key ARN used for user data and database encryption."
  value       = module.kms.database_encryption_kms_key_arn
}
output "database_encryption_kms_key_arn" {
  description = "KMS key ARN used for database encryption."
  value       = module.kms.database_encryption_kms_key_arn
}
output "iam_role_arn" {
  description = "IAM role ARN."
  value       = module.iam.api_role_arn
}
output "iam_instance_profile" {
  description = "IAM instance profile."
  value       = module.iam.cp_instance_profile_id
}
output "service_address_cidr_blocks" {
  value = var.service_address_cidr_blocks
}
output "pod_address_cidr_blocks" {
  value = var.pod_address_cidr_blocks
}