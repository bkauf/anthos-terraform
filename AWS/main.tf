



module "kms" {
  source = "./modules/kms"
  anthos_prefix             = var.anthos_prefix

}






#module "iam" {
#  source = "./modules/iam"
#  gcp_project_number        = var.gcp_project_number
#  anthos_prefix             = var.anthos_prefix
#  db_kms_arn                = "${module.kms.database_encryption_kms_key_arn}"
#}

module "vpc" {
  source = "./modules/vpc"

 aws_region                        = var.aws_region
 vpc_cidr_block                    = var.vpc_cidr_block
 anthos_prefix                     = var.anthos_prefix
 #database_encryption_kms_key_arn   = "${module.kms.database_encryption_kms_key_arn}"

subnet_availability_zones       = var.subnet_availability_zones
public_subnet_cidr_block       = var.public_subnet_cidr_block
private_subnet_cidr_blocks      = var.private_subnet_cidr_blocks

 }


 # Export Relevant values 

locals {
  anthos-params = {
    AZURE_REGION      = var.aws_region
    CP_SUBNET_1_ID    = module.vpc.aws_subnet_pri_1
    CP_SUBNET_2_ID    = module.vpc.aws_subnet_pri_2
    CP_SUBNET_3_ID    = module.vpc.aws_subnet_pri_3
    CP_SUBNET_4_ID    = module.vpc.aws_subnet_pri_4
    SUBNET_PUBLIC_ID  = module.vpc.aws_subnet_public
    DB_KMS_KEY_ARN    = module.kms.database_encryption_kms_key_arn
 
  }
}
resource "local_file" "outputdata" {
  filename = "anthos-params.json"
  content  = jsonencode(local.anthos-params)
}






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
