# GKE on AWS Terraform

## Notes:
![Anthos Multi-Cloud](Anthos-Multi-AWS.png)

This terraform script will install all relevant [IaaS prerequisites](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/prerequisites) in AWS(VPC, IAM roles, route tables, and KMS) and then deploy Anthos GKE with 3 control plane nodes(1 in each AZ) of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/) and a single node pool of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/)  with 1 node in an autoscaling group to max 3 nodes to the AWS us-east-1 region. Supported instance types in AWS can be found [here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/reference/supported-instance-types).  After the cluster has been installed it will show up in your GKE page of the GCP console in your relevant GCP project. For best results please run this script in [GCP Cloud Shell](https://cloud.google.com/shell/docs/using-cloud-shelll). The Multi-Cloud API is regonal - For a list of Azure regions and assocaited K8s version supported per GCP region please use this command:

```bash
gcloud container azure get-server-config --location [gcp-region]
```

 This script is meant to be a quick start to working with Anthos on Azure. For more information on Anthos Multi-Cloud please [click here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/).

## Prerequisites

1. Ensure you have gCloud SDK 365.0.1 or greater [installed](https://cloud.google.com/sdk/docs/install)
```
gcloud component update
```

1. Configure GCP Terraform authentication.

   ```bash
   echo PROJECT_ID=Your GCP Project ID

   gcloud config set project "${PROJECT_ID}"
   gcloud auth application-default login --no-launch-browser
   ```

1. Enable services in your GCP project.

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

   > You can also enable services in Terraform. Take care when destroying your terraform plan as it will also disable those services. For demo purposes, enable the main services here.

1. Clone this repo and go into the aws folder.

   ```bash
   git clone https://github.com/bkauf/anthos-terraform.git
   cd anthos-terraform/aws
   ```

1. Install the AWS CLI

   Linux below, others can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
   ```

   Setup the AWS CLI with your [access key and secret](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html#getting-started-prereqs-keys)
   ```bash
   aws configure
   ```

## Deploy Anthos Clusters(GKE) on AWS

1. Initialize and create terraform plan.

   ```bash
   terraform init

   ```

1. Apply terraform.

   ```bash
   terraform apply 
   ```
   You will be then asked for your cluster name, GCP project name, and project ID. Once started the installation process will take about 10 minutes.

1. Authorize Cloud Logging / Cloud Monitoring

   Enable logging if this is your first cluster in this project. You can only do this after the first cluster has been created. 
   ( [read more](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-cluster#telemetry-agent-auth) )

   ``` bash
   gcloud projects add-iam-policy-binding ${PROJECT_ID} \
   --member="serviceAccount:${PROJECT_ID}.svc.id.goog[gke-system/gke-telemetry-agent]" \
   --role=roles/gkemulticloud.telemetryWriter
   ```


 1. Login to the Cluster

   ``` bash
   gcloud container hub memberships get-credentials [cluster name]
   kubectl get nodes
   ```

## Delete Anthos on Azure cluster

1. Run the following command to delete Anthos on Azure cluster.

   ```bash
   terraform destroy 
   ```


