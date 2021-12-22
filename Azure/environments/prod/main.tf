locals {
  tags = {
    "creation_time" = timestamp()
   # "owner"         = var.owner
  }
}

resource "tls_private_key" "anthos-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


module "aad-app" {
  source           = "../../modules/aad-app"
  application_name = "${var.azure_cluster}-app"
 
}

module "cluster-vnet" {
  source = "../../modules/cluster-vnet"

  name                = "${var.azure_cluster}-vnet"
  region              = var.region
  vnet_resource_group = "${var.azure_cluster}-vnet-rg"
  aad_app_name        = "${var.azure_cluster}-app"
  sp_obj_id           = module.aad-app.aad_app_sp_obj_id
  subscription_id     = module.aad-app.subscription_id
  depends_on = [
    module.aad-app
  ]
  # create_proxy = var.create_proxy
}

module "cluster-rg" {
  source    = "../../modules/cluster-rg"
  name      = "${var.azure_cluster}-cluster-rg"
  region    = module.cluster-vnet.location
  sp_obj_id = module.aad-app.aad_app_sp_obj_id
  #owner     = var.owner
  tags      = local.tags
  depends_on = [
    module.aad-app
  ]
}

module "create_azure_client" {
  source = "terraform-google-modules/gcloud/google"

  platform              = "linux"
  additional_components = ["alpha"]

  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "container azure clients create ${var.azure_cluster}-client --location=${var.gcp_region} --tenant-id=${module.aad-app.tenant_id} --application-id=${module.aad-app.aad_app_id}"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "container azure clients delete ${var.azure_cluster}-client --location=${var.gcp_region} --quiet"
}

data "external" "azure_client_cert" {
  program = ["bash", "${path.module}/scripts/azure_client_cert.sh"]
  query = {
    GCP_REGION   = var.gcp_region
    AZURE_CLIENT = "${var.azure_cluster}-client"
  }
  depends_on = [
    module.create_azure_client
  ]
}

resource "azuread_application_certificate" "aad_app_azure_client_cert" {
  application_object_id = module.aad-app.aad_app_obj_id
  type                  = "AsymmetricX509Cert"
  value                 = data.external.azure_client_cert.result.AZURE_CLIENT_CERT
  end_date_relative     = "8760h"
}

module "create_anthos_on_azure_cluster" {
  source = "terraform-google-modules/gcloud/google"

  platform              = "linux"
  additional_components = ["alpha"]

  create_cmd_entrypoint = "${path.module}/scripts/azure_cluster.sh"
  create_cmd_body       = "\"${var.azure_cluster}\" \"${var.gcp_region}\" \"${var.azure_cluster}-client\" \"${var.gcp_azure_location}\" \"${tls_private_key.anthos-ssh-key.public_key_openssh}\" \"${module.cluster-rg.resource_group_id}\" \"${module.cluster-vnet.vnet_id}\" \"${module.cluster-vnet.subnet_id}\" \"${var.gcp_project_id}\""
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "container azure clusters delete ${var.azure_cluster} --location ${var.gcp_region} --quiet"
  module_depends_on      = [azuread_application_certificate.aad_app_azure_client_cert]
}

module "create_anthos_on_azure_node_pool" {
  source = "terraform-google-modules/gcloud/google"

  platform              = "linux"
  additional_components = ["alpha"]

  create_cmd_entrypoint  = "${path.module}/scripts/azure_cluster_nodepool.sh"
  create_cmd_body        = "\"${var.azure_cluster}-np-1\" \"${var.azure_cluster}\" \"${var.gcp_region}\" \"${tls_private_key.anthos-ssh-key.public_key_openssh}\" \"${module.cluster-vnet.subnet_id}\""
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "container azure node-pools delete ${var.azure_cluster}-np-1 --cluster ${var.azure_cluster} --location ${var.gcp_region} --quiet"
  module_depends_on      = [module.create_anthos_on_azure_cluster.wait]
}


