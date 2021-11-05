



module "kms" {
  source = "./modules/kms"
  anthos_prefix             = var.anthos_prefix

}






module "iam" {
  source = "./modules/iam"
  gcp_project_number        = var.gcp_project_number
  anthos_prefix             = var.anthos_prefix
  db_kms_arn                = "${module.kms.database_encryption_kms_key_arn}"
}


#module "proxy" {
#  count = var.create_proxy ? 1 : 0
#  source = "../modules/proxy"

#  region                  = var.region
#  dev_workspace           = var.dev_workspace
#  vpc_id                  = module.vpc.vpc_id
#  private_route_table_ids = module.vpc.private_route_table_ids
#  private_subnets         = module.vpc.private_subnets
#  allowed_ssh_cidr_blocks = var.extra_ssh_cidr_blocks
#  root_volume_kms_key_arn = var.proxy_root_volume_kms_key_arn
#  ssh_key_name            = module.vpc.ec2_key_pair
#  subnet_id               = module.vpc.public_subnets[0]
#  tags                    = local.tags
#}

#module "vpc" {
#  source = "../modules/vpc"

 # region                          = var.region
 # dev_workspace                   = var.dev_workspace
 # vpc_cidr_block                  = var.vpc_cidr_block
 # subnet_availability_zones       = var.subnet_availability_zones
 # public_subnet_cidr_blocks       = var.public_subnet_cidr_blocks
 # private_subnet_cidr_blocks      = var.private_subnet_cidr_blocks
 # ssh_public_key                  = var.ssh_public_key
 # iam_role_path                   = var.iam_role_path
 # database_encryption_kms_key_arn = module.kms.database_encryption_kms_key_arn
 # tags                            = local.tags
 # use_proxy                       = var.create_proxy
 # proxy_secret_arn                = var.create_proxy ? module.proxy[0].secret_arn : ""
#}

#module "bastion" {
#  source = "../modules/bastion"

#  dev_workspace           = var.dev_workspace
#  subnet_id               = module.vpc.public_subnets[0]
#  root_volume_kms_key_arn = var.bastion_root_volume_kms_key_arn
#  ssh_key_name            = module.vpc.ec2_key_pair
#  allowed_ssh_cidr_blocks = var.extra_ssh_cidr_blocks
#  region                  = var.region
#  tags                    = local.tags
#}
