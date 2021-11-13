#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

env CLOUDSDK_API_ENDPOINT_OVERRIDES_GKEMULTICLOUD=$1 gcloud container aws clusters create $2 \
  --location=$3 \
  --aws-region=$4 \
  --cluster-version=$5 \
  --config-encryption-kms-key-arn=$6 \
  --database-encryption-kms-key-arn=$6 \
  --iam-instance-profile=$7 \
  --pod-address-cidr-blocks="10.2.0.0/16" \
  --role-arn=$8 \
  --service-address-cidr-blocks="10.1.0.0/16" \
  --subnet-ids=$9 \
  --vpc-id=${10} \
  --service-load-balancer-subnet-ids=$9 \
  --fleet-project=${11}