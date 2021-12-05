# GKE on Azure Terraform

## Notes:
![Anthos Multi-Cloud](Anthos-Multi-Azure.png)

This terraform script will install all relevant IaaS in Azure(VNet, App Registration, Resource Groups, KMS) and then deploy Anthos GKE with 3 control plane nodes(1 in each AZ) of type [Standard_B2s](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable) and a single node pool of type [Standard_D4s_v3](https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series)  with 1 node in an autoscaling group to max 2 nodes to the Azure East US region. Supported instance types in Azure can be found [here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/azure/reference/supported-vms).  After the cluster has been installed it will show up in your GKE page of the GCP console in your relevant GCP project. For best results please run this script in [GCP Cloud Shell](https://cloud.google.com/shell/docs/using-cloud-shelll). The Multi-Cloud API is regonal - For a list of Azure regions and assocaited K8s version supported per GCP region please use this command:

```bash
gcloud alpha container azure get-server-config --location [gcp-region]
```

 This script is meant to be a quick start to working with Anthos on Azure. For more information on Anthos Multi-Cloud please [click here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/).

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
   gkemulticloud.googleapis.com \
   gkeconnect.googleapis.com \
   connectgateway.googleapis.com \
   cloudresourcemanager.googleapis.com \
   anthos.googleapis.com \
   logging.googleapis.com \
   monitoring.googleapis.com
   ```

   > You can also enable services in Terraform. Take care when destroying your terraform plan as it will also disable those services. For demo purposes, enable the main services here and only the services required for Anthos on Azure (i.e. the gkemulticloud.googleapis.com) through terraform.

1. Clone this repo and go into the environments/prod folder.

   ```bash
   git clone https://github.com/bkauf/anthos-terraform.git
   cd anthos-terraform/Azure/environments/prod
   ```

## Deploy Anthos on Azure cluster

1. Initialize and create terraform plan.

   ```bash
   terraform init
   terraform plan -out terraform.tfplan
   ```

1. Apply terraform.

   You will need to supply your cluster name and also your project ID

   ```bash
   terraform apply -input=false terraform.tfplan
   ```
1. Authorize Cloud Logging / Cloud Monitoring

   Enable system container logging and container metrics. You can only do this after the first Anthos cluster has been created. 
   ( [read more](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-cluster#telemetry-agent-auth) )

   ``` bash
   gcloud projects add-iam-policy-binding ${PROJECT_ID} \
   --member="serviceAccount:${PROJECT_ID}.svc.id.goog[gke-system/gke-telemetry-agent]" \
   --role=roles/gkemulticloud.telemetryWriter
   ```

 1. Login to the Cluster

   ```bash
   gcloud container hub memberships get-credentials $AZURE_CLUSTER
   kubectl get nodes
   ```

## Delete Anthos on Azure cluster

1. Run the following command to delete Anthos on Azure cluster.

   ```bash
   terraform destroy --auto-approve
   ```


