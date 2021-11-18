locals {
  tags = {
    "owner"                    = "${var.owner}"
    "gke:multicloud:toolchain" = "terraform"
  }
}

resource "tls_private_key" "anthos_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# module "project_services" {
#   source = "terraform-google-modules/project-factory/google//modules/project_services"

#   project_id = var.gcp_project

#   activate_apis = [
#     "gkemulticloud.googleapis.com",
#   ]
# }

module "aad_app" {
  source           = "../../modules/aad-app"
  gcp_project      = var.gcp_project
  application_name = "${var.anthos_prefix}-azure-app"
}

module "cluster_vnet" {
  source = "../../modules/cluster-vnet"

  name            = "${var.anthos_prefix}-azure-vnet"
  region          = var.region
  aad_app_name    = "${var.anthos_prefix}-azure-app"
  sp_obj_id       = module.aad_app.aad_app_sp_obj_id
  subscription_id = module.aad_app.subscription_id
  depends_on = [
    module.aad_app
  ]
  # create_proxy = var.create_proxy
}

module "cluster_rg" {
  source    = "../../modules/cluster-rg"
  name      = "${var.anthos_prefix}-azure-resource-group"
  region    = var.region
  sp_obj_id = module.aad_app.aad_app_sp_obj_id
  owner     = var.owner
  tags      = local.tags
  depends_on = [
    module.aad_app
  ]
}

module "anthos_cluster" {
  source                = "../../modules/anthos_cluster"
  admin_user            = var.admin_user
  anthos_prefix         = var.anthos_prefix
  resource_group_id     = module.cluster_rg.resource_group_id
  subnet_id             = module.cluster_vnet.subnet_id
  ssh_public_key        = tls_private_key.anthos_ssh_key.public_key_openssh
  project_number        = var.gcp_project_number
  virtual_network_id    = module.cluster_vnet.vnet_id
  tenant_id             = module.aad_app.tenant_id
  application_id        = module.aad_app.aad_app_id
  application_object_id = module.aad_app.aad_app_obj_id
  fleet_project         = "projects/${var.gcp_project_number}"
  depends_on = [
    module.aad_app, module.cluster_rg, module.cluster_vnet
  ]
}

module "hub_feature" {
  source     = "../../modules/hub_feature"
  membership = "projects/${var.gcp_project_number}/locations/global/memberships/${module.anthos_cluster.cluster_name}"
  depends_on = [module.anthos_cluster]
}


