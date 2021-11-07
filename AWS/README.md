# GKE on Azure Terraform

## Prerequisites

1. Run  this terraform
```
terraform init
teffaform apply
```

2. Collect the output variables in the 'anthos-params.json' and put them into the following envoirnmental variables
```
  export CLUSTER_NAME=[fill in]
  export AWS_REGION=[fill in]
  export API_ROLE_ARN=[fill in]
  export CONTROL_PLANE_PROFILE=[fill in]
  export DB_KMS_KEY_ARN=[fill-in]
  export AWS_VPC_1_SUBNET_5_PUBLIC_ID=[fill in]
  export AWS_VPC_1_SUBNET_4_PRIV_ID=[fill in]
  export AWS_VPC_ID=[fill in]
  export AWS_CLUSTER_1_SVC_CIDR=[fill in]
  export AWS_CLUSTER_1_POD_CIDR=[fill in]
  export AWS_VPC_1_SUBNET_1_PRIV_ID=[fill in]
  export AWS_VPC_1_SUBNET_2_PRIV_ID=[fill in]
  export AWS_VPC_1_SUBNET_3_PRIV_ID=[fill in]
  export AWS_CLUSTER_GCP_REGION=[fill in]
  ```

 3. Enable the GCP APIs
 ```
gcloud services enable gkemulticloud.googleapis.com
gcloud services enable anthos.googleapis.com
gcloud services enable gkeconnect.googleapis.com
```

If this is the first cluster that you create in your Google Cloud project, you need to add an Identity and Access Management (IAM) policy binding to a Google Cloud service account.

 WILL NOT NEED THIS IN GA

```
gcloud projects add-iam-policy-binding "$GCP_PROJECT_ID" \
--member="serviceAccount:$GCP_PROJECT_ID.svc.id.goog[gke-system/gke-multicloud-agent]" \
--role="roles/gkehub.connect"
```




6. Create your GKE cluster in AWS

#### Control Plane


```
gcloud alpha container aws clusters create ${CLUSTER_NAME} \
  --project=${PROJECT_ID} \
  --aws-region=$AWS_DEFAULT_REGION --location=${AWS_CLUSTER_GCP_REGION} \
  --subnet-ids=${AWS_VPC_1_SUBNET_1_PRIV_ID},${AWS_VPC_1_SUBNET_2_PRIV_ID},${AWS_VPC_1_SUBNET_3_PRIV_ID} \
  --pod-address-cidr-blocks=${AWS_CLUSTER_1_POD_CIDR} \
  --service-address-cidr-blocks=${AWS_CLUSTER_1_SVC_CIDR} \
  --vpc-id=${AWS_VPC_1_ID} \
  --service-load-balancer-subnet-ids=${AWS_VPC_1_SUBNET_5_PUBLIC_ID},${AWS_VPC_1_SUBNET_4_PRIV_ID} \
  --cluster-version=1.20.10-gke.300 \
  --database-encryption-kms-key-arn=${DB_KMS_KEY_ARN} \
  --iam-instance-profile=${CONTROL_PLANE_PROFILE} \
  --instance-type=t3.medium \
  --ssh-ec2-key-pair=${GCLOUD_USER%@*}-anthos-ssh-key \
  --main-volume-size=10 \
  --root-volume-size=10 \
  --role-arn=${API_ROLE_ARN} \
  --role-session-name="multicloud-service-agent"
```
#### Create a Node Pool

```
gcloud alpha container aws node-pools create ${AWS_CLUSTER_1_NODE_POOL} \
  --project=${PROJECT_ID} \
  --cluster=${AWS_CLUSTER_1} --instance-type=t3.medium \
  --ssh-ec2-key-pair=${GCLOUD_USER%@*}-anthos-ssh-key --root-volume-size=10 \
  --iam-instance-profile=${GCLOUD_USER%@*}-amc-nodepool-profile --node-version=1.19.10-gke.1000 \
  --min-nodes=4 --max-nodes=6 --max-pods-per-node=110 \
  --location=${AWS_CLUSTER_GCP_REGION} \
  --subnet-id=${AWS_VPC_1_SUBNET_4_PRIV_ID}
```