<<<<<<< HEAD
=======


>>>>>>> main
module "kms" {
  source        = "./modules/kms"
  anthos_prefix = var.anthos_prefix
}

module "iam" {
  source             = "./modules/iam"
  gcp_project_number = module.gcp_data.project_number
  anthos_prefix      = var.anthos_prefix
  db_kms_arn         = module.kms.database_encryption_kms_key_arn
}

module "vpc" {
  source                        = "./modules/vpc"
  aws_region                    = var.aws_region
  vpc_cidr_block                = var.vpc_cidr_block
  anthos_prefix                 = var.anthos_prefix
  subnet_availability_zones     = var.subnet_availability_zones
  public_subnet_cidr_block      = var.public_subnet_cidr_block
  cp_private_subnet_cidr_blocks = var.cp_private_subnet_cidr_blocks
  np_private_subnet_cidr_blocks = var.np_private_subnet_cidr_blocks
}

<<<<<<< HEAD
module "gcp_data" {
  source       = "./modules/gcp_data"
  gcp_location = var.gcp_location
  gcp_project  = var.gcp_project
}

module "anthos_cluster" {
  source                          = "./modules/anthos_cluster"
  anthos_prefix                   = var.anthos_prefix
  location                        = var.gcp_location
  aws_region                      = var.aws_region
  cluster_version                 = coalesce(var.cluster_version, module.gcp_data.latest_version)
  database_encryption_kms_key_arn = module.kms.database_encryption_kms_key_arn
  iam_instance_profile            = module.iam.cp_instance_profile_id
  admin_user                      = var.admin_user
  vpc_id                          = module.vpc.aws_vpc_id
  role_arn                        = module.iam.api_role_arn
  subnet_ids                      = [module.vpc.aws_cp_subnet_id_1, module.vpc.aws_cp_subnet_id_2, module.vpc.aws_cp_subnet_id_3]
  node_pool_subnet_id             = module.vpc.aws_np_subnet_id_1
  fleet_project                   = "projects/${module.gcp_data.project_number}"
  depends_on                      = [module.kms, module.iam, module.vpc]
}

module "hub_feature" {
  source     = "./modules/hub_feature"
  membership = module.anthos_cluster.fleet_membership
  depends_on = [module.anthos_cluster]
=======
module "create_anthos_on_aws_cluster" {
  source                 = "terraform-google-modules/gcloud/google"
  platform               = "linux"
  create_cmd_entrypoint  = "${path.module}/scripts/create_aws_cluster.sh"
  create_cmd_body        = "\"${var.anthos_prefix}\" \"${var.gcp_location}\" \"${var.aws_region}\" \"${var.cluster_version}\" \"${module.kms.database_encryption_kms_key_arn}\" \"${module.iam.cp_instance_profile_id}\" \"${module.iam.api_role_arn}\" \"${module.vpc.aws_cp_subnet_id_1},${module.vpc.aws_cp_subnet_id_2},${module.vpc.aws_cp_subnet_id_3}\" \"${module.vpc.aws_vpc_id}\" \"${var.gcp_project_id}\" \"${var.pod_address_cidr_blocks}\" \"${var.service_address_cidr_blocks}\""
  destroy_cmd_entrypoint = "${path.module}/scripts/delete_aws_cluster.sh"
  destroy_cmd_body       = "\"${var.anthos_prefix}\" \"${var.gcp_location}\""
  module_depends_on      = [module.vpc, module.kms, module.iam]
}

module "create_anthos_on_aws_node_pool" {
  source                 = "terraform-google-modules/gcloud/google"
  platform               = "linux"
  create_cmd_entrypoint  = "${path.module}/scripts/create_aws_nodepool.sh"
  create_cmd_body        = "\"${var.anthos_prefix}-np\" \"${var.anthos_prefix}\" \"${var.gcp_location}\" \"${var.cluster_version}\" \"${module.kms.database_encryption_kms_key_arn}\" \"${module.iam.np_instance_profile_id}\" \"${module.vpc.aws_np_subnet_id_1}\" \"${var.node_pool_instance_type}\""
  destroy_cmd_entrypoint = "${path.module}/scripts/delete_aws_nodepool.sh"
  destroy_cmd_body       = "\"${var.anthos_prefix}-np\" \"${var.anthos_prefix}\" \"${var.gcp_location}\""
  module_depends_on      = [module.create_anthos_on_aws_cluster.wait]
>>>>>>> main
}





