# GKE on Azure Terraform

## Notes:

This terraform script will install all relevant IaaS in Azure(VNet, App Registration, Resource Groups, KMS) and then deploy Anthos GKE and a single node pool to the Azure East US region. After the cluster has been installed it will show up in your GKE page of the GCP console in your relevant GCP project. For best results please run this script in [GCP Cloud Shell](https://cloud.google.com/shell/docs/using-cloud-shelll). This script is meant to be a
quick start to working with Anthos on Azure. 

## Prerequisites

1. Download the `az` CLI utility. Ensure it is in your `$PATH`.

   ```bash
   curl -L https://aka.ms/InstallAzureCli | bash
   ```

1. Log in to your Azure account and get account details.

   ```bash
   az login
   ```

1. Set the following variables for Azure Terraform authentication. The example uses [Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) way of authenticating Terraform.

   ```bash
   export ARM_SUBSCRIPTION_ID=$(az account show --query "id" --output tsv)
   export ARM_TENANT_ID=$(az account list --query "[?id=='${ARM_SUBSCRIPTION_ID}'].{tenantId:tenantId}" --output tsv)

   echo -e "ARM_SUBSCRIPTION_ID is ${ARM_SUBSCRIPTION_ID}"
   echo -e "ARM_TENANT_ID is ${ARM_TENANT_ID}"
   ```

   Ouput looks like the following

   ```
   ARM_SUBSCRIPTION_ID is abcdef123-abcd-1234-aaaa-12345abcdef
   ARM_TENANT_ID is 1230982dfd-123a-1234-7a54-12345abcdef
   ```

## Prepare terraform

1. Configure GCP Terraform authentication.

   ```bash
   echo PROJECT_ID=Your GCP Project ID
   echo GCLOUD_USER=You Google user email

   gcloud config set project "${PROJECT_ID}"
   gcloud auth application-default login --no-launch-browser
   ```

1. Enable services.

   ```bash
   gcloud --project="${PROJECT_ID}" services enable \
   container.googleapis.com \
   compute.googleapis.com \
   gkehub.googleapis.com \
   gkeconnect.googleapis.com \
   anthos.googleapis.com \
   cloudresourcemanager.googleapis.com
   ```

   > You can also enable services in Terraform. Take care when destroying your terraform plan as it will also disable those services. For demo purposes, enable the main services here and only the services required for Anthos on Azure (i.e. the gkemulticloud.googleapis.com) through terraform.

1. Clone this repo and go into the environments/prod folder.

   ```bash
   git clone https://github.com/bkauf/anthos-terraform.git
   cd anthos-terraform/Azure/environments/prod
   ```

1. Define terraform variables.

   ```bash
   AZURE_CLUSTER=${GCLOUD_USER%@*}-anthos-cluster-1
   AZURE_NODEPOOL=${GCLOUD_USER%@*}-anthos-cluster-1-nodepool-1
   AZURE_REGION="East US"
   GCP_USER=${GCLOUD_USER}
   GCP_PROJECT_ID=${PROJECT_ID}
   GCP_REGION="us-east4"
   GCP_AZURE_LOCATION="eastus"
   APP_NAME=${GCLOUD_USER%@*}-app
   CLUSTER_RESOURCE_GROUP_NAME=${GCLOUD_USER%@*}-cluster-rg
   VNET_RESOURCE_GROUP_NAME=${GCLOUD_USER%@*}-vnet-rg
   VNET_NAME=${GCLOUD_USER%@*}-vnet
   AZURE_CLIENT=${GCLOUD_USER%@*}-az-client
   AZURE_ROLE_ADMIN_NAME=${GCLOUD_USER%@*}-role-admin
   AZURE_ROLE_VNET_ADMIN_NAME=${GCLOUD_USER%@*}-role-vnet-admin

   sed -e "s/AZURE_REGION/$AZURE_REGION/" -e "s/GCP_USER/$GCP_USER/" \
       -e "s/GCP_PROJECT_ID/$GCP_PROJECT_ID/" -e "s/GCP_REGION/$GCP_REGION/" \
       -e "s/APP_NAME/$APP_NAME/" -e "s/CLUSTER_RESOURCE_GROUP_NAME/$CLUSTER_RESOURCE_GROUP_NAME/" \
       -e "s/VNET_RESOURCE_GROUP_NAME/$VNET_RESOURCE_GROUP_NAME/" -e "s/VNET_NAME/$VNET_NAME/" \
       -e "s/AZURE_ROLE_ADMIN_NAME/$AZURE_ROLE_ADMIN_NAME/" -e "s/AZURE_ROLE_VNET_ADMIN_NAME/$AZURE_ROLE_VNET_ADMIN_NAME/" \
       -e "s/AZURE_CLIENT/$AZURE_CLIENT/" -e "s/AZURE_CLUSTER/$AZURE_CLUSTER/" \
       -e "s/GCP_AZURE_LOCATION/$GCP_AZURE_LOCATION/" -e "s/AZURE_NODEPOOL/$AZURE_NODEPOOL/" \
          variables.tf.tmpl > variables.tf
   ```

## Deploy Anthos on Azure cluster

1. Initialize and create terraform plan.

   ```bash
   terraform init
   terraform plan -out terraform.tfplan
   ```

1. Apply terraform.

   ```bash
   terraform apply -input=false terraform.tfplan
   ```

## Delete Anthos on Azure cluster

1. Run the following command to delete Anthos on Azure cluster.

   ```bash
   terraform destroy --auto-approve
   ```


