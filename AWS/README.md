# Anthos on AWS Terraform

## Notes:
![Anthos Multi-Cloud](Anthos-Multi-AWS.png)

This terraform script will install all relevant [IaaS prerequisites](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/prerequisites) in AWS (VPC, subnets, internet gateay, NAT gateway, IAM roles, route tables, and KMS) and then deploy an Anthos cluster on AWS with 3 control plane nodes (1 in each AZ) of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/) and a single node pool of type [t3.medium](https://aws.amazon.com/ec2/instance-types/t3/)  with 2 nodes in an autoscaling group to max 5 nodes to the AWS `us-east-1` region. The node pool will be deployed to the `us-east-1a zone`. The network topology setup is documented [here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc#create-sample-vpc).  You can adjust the region and AZs in a `terraform.tfvars` file. For a list of AWS regions and associated K8s version supported per GCP region, please use this command:

```bash
gcloud container aws get-server-config --location [gcp-region]
```
 Supported instance types in AWS can be found [here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/reference/supported-instance-types).  After the cluster has been installed it will show up in your GKE page of the GCP console in your relevant GCP project. 

 This script is meant to be a quick start to working with Anthos on AWS. For more information on Anthos Multi-Cloud please [click here](https://cloud.google.com/anthos/clusters/docs/multi-cloud/).

## Prerequisites

1. Ensure you have Google Cloud SDK 365.0.1 or greater [installed](https://cloud.google.com/sdk/docs/install).
   ```bash
   gcloud component update
   ```

1. Configure GCP Terraform authentication.
   ```bash
   PROJECT_ID=Your GCP Project ID

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
   cd anthos-terraform/AWS
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

1. Set the following variables in a `terraform.tfvars` file. Alternatively, you can set them when running `terraform apply`. 

   ```
   gcp_project_id = "your-gcp-project-id"
   admin_user     = "user@example.com"
   ```

   The example creates a cluster in AWS region `us-east-1` and managed in GCP location `us-east4`. To change the defaults, set the following variables in the `terraform.tfvars` file.

   ```
   aws_region   = "us-west-2"
   gcp_location = "us-west1"
   subnet_availability_zones = [
   "us-west-2a",
   "us-west-2b",
   "us-west-2c",
   ]
   ```

1. Initialize and create terraform plan.

   ```bash
   terraform init
   terraform apply 
   ```

    Once started the installation process will take about 10 minutes. **After the script completes you will see a var.sh file in the root directory that has varialbles for the anthos install** if you need to create more node pools manually in the future.

1. Authorize Cloud Logging / Cloud Monitoring

   Enable system container logging and container metrics. You can only do this after the first Anthos cluster has been created. 
   ([read more](https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-cluster#telemetry-agent-auth))

   ``` bash
   gcloud projects add-iam-policy-binding ${PROJECT_ID} \
   --member="serviceAccount:${PROJECT_ID}.svc.id.goog[gke-system/gke-telemetry-agent]" \
   --role=roles/gkemulticloud.telemetryWriter
   ```


 1. Login to the Cluster

   ``` bash
   gcloud container aws clusters get-credentials [cluster name]
   kubectl get nodes
   ```


## Delete Anthos on AWS Cluster

1. Run the following command to delete Anthos on AWS cluster and its prerequisites.

   ```bash
   terraform destroy 
   ```


