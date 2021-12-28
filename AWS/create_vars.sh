#!/bin/bash

# create vars.sh file

tf_out () {
  terraform output -json $@
}

set -e

cat <<EOF > vars.sh
export CLUSTER_NAME=$(tf_out cluster_name)
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export PROJECT_NUMBER=$(gcloud projects describe `gcloud info --format='value(config.project)'` --format='value(projectNumber)')
export GCP_LOCATION=$(tf_out  gcp_location)
export AWS_REGION=$(tf_out aws_region)
export VPC_ID=$(tf_out vpc_id)
export SUBNET_IDS=$(tf_out subnet_ids)
export CLUSTER_VERSION=$(tf_out cluster_version)
export CONFIG_ENCRYPTION_KMS_KEY_ARN=$(tf_out encryption_kms_key_arn)
export DATABASE_ENCRYPTION_KMS_KEY_ARN=$(tf_out encryption_kms_key_arn)
export CP_IAM_ROLE_ARN=$(tf_out iam_role_arn)
export CP_IAM_INSTANCE_PROFILE=$(tf_out iam_instance_profile)
export SERVICE_ADDRESS_CIDR_BLOCKS=$(tf_out service_address_cidr_blocks)
export NODE_POOL_IAM_INSTANCE_PROFILE=$(tf_out iam_instance_profile)

EOF