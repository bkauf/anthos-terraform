
locals {
  tags = {
    "creation_time"                = timestamp()
    "owner"                        = var.owner
 
  }
}


module "aad-app" {
  source             = "./modules/aad-app"
  gcp_project        = var.gcp_project
  application_name   = var.application_name

}

module "cluster-vnet" {
  source = "./modules/cluster-vnet"

  name         = var.vnet_name
  region       = var.region
  vnet_resource_group = var.vnet_resource_group
  aad_app_name        = module.aad-app.aad_app_name
  sp_obj_id           = module.aad-app.aad_app_sp_obj_id
  subscription_id     = module.aad-app.subscription_id

 # create_proxy = var.create_proxy
}

 module "cluster-rg" {
  source = "./modules/cluster-rg"
  name            = var.name
  region          = var.region
  sp_obj_id       = module.aad-app.aad_app_sp_obj_id
  owner           = var.owner
  tags            = local.tags
}

# Export Relevant values 

locals {
  anthos-params = {
    AZURE_REGION = var.region
    CLUSTER_RG_ID = module.cluster-rg.resource_group_id
    VNET_ID = module.cluster-vnet.vnet_id
    CLUSTER_NAME = var.name
    SUBNET_ID = module.cluster-vnet.subnet_id
  }
}
resource "local_file" "outputdata" {
  filename = "anthos-params.json"
  content  = jsonencode(local.anthos-params)
}












#module "bastion" {
#  source = "../modules/bastion"

 # subnet_id         = module.cluster-vnet.subnet_id
 # resource_group_id = module.cluster-vnet.resource_group_id
 # location          = var.region
 # public_ssh_key    = var.ssh_pub_key
 # ssh_cidr_blocks   = var.extra_ssh_cidr_blocks
#}

#module "proxy" {
#  count  = var.create_proxy ? 1 : 0
#  source = "../modules/proxy"

# tenant_id           = module.aad-app.tenant_id
#  resource_group_name = module.cluster-vnet.resource_group_name
#  location            = var.region
#  subnet_id           = module.cluster-vnet.subnet_id
#  subnet_cidr         = module.cluster-vnet.subnet_address_prefixes
#  podsubnet_cidr      = module.cluster-vnet.pod_subnet.address_prefixes
#  nsg_name            = module.cluster-vnet.subnet_nsg.name
#  public_ssh_key      = var.ssh_pub_key
#  tags                = local.tags
#}

