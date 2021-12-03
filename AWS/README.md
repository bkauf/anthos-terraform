# GKE on AWS Terraform

## Notes:
![Anthos Multi-Cloud](Anthos-Multi-AWS.png)

This terraform script will install all relevant IaaS prerequisites in AWS(VPC, IAM roles, route tables, and KMS) and then deploy Anthos GKE with 3 control plane nodes(1 in each AZ) of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/) and a single node pool of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/)  with 1 node in an autoscaling group to max 3 nodes to the AWS us-east-1 region. Supported instance types in AWS can be found [here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/azure/reference/supported-vms).  After the cluster has been installed it will show up in your GKE page of the GCP console in your relevant GCP project. For best results please run this script in [GCP Cloud Shell](https://cloud.google.com/shell/docs/using-cloud-shelll). The Multi-Cloud API is regonal - For a list of Azure regions and assocaited K8s version supported per GCP region please use this command:

```bash
gcloud alpha container azure get-server-config --location [gcp-region]
```

 This script is meant to be a quick start to working with Anthos on Azure. For more information on Anthos Multi-Cloud please [click here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/).

## Prerequisites


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
   gkemulticloud.googleapis.com\
   gkeconnect.googleapis.com \
   connectgateway.googleapis.com \
   cloudresourcemanager.googleapis.com \
   anthos.googleapis.com \
   logging.googleapis.com \
   monitoring.googleapis.com
   ```
  Authorize Cloud Loggign / Cloud Monitoring([read more[https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-cluster#telemetry-agent-auth]])
  ``` bash
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${PROJECT_ID}.svc.id.goog[gke-system/gke-telemetry-agent]" \
  --role=roles/gkemulticloud.telemetryWriter
  ```

   > You can also enable services in Terraform. Take care when destroying your terraform plan as it will also disable those services. For demo purposes, enable the main services here.

1. Clone this repo and go into the environments/prod folder.

   ```bash
   git clone https://github.com/bkauf/anthos-terraform.git
   cd anthos-terraform/aws
   ```

1
  

## Deploy Anthos on Azure cluster

1. Initialize and create terraform plan.

   ```bash
   terraform init

   ```

1. Apply terraform.

   ```bash
   terraform apply 
   ```
 1. Login to the Cluster

   ```bash
   gcloud container hub memberships get-credentials [cluster name]
   kubectl get nodes
   ```

## Delete Anthos on Azure cluster

1. Run the following command to delete Anthos on Azure cluster.

   ```bash
   terraform destroy 
   ```


