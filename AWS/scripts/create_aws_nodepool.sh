#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

env CLOUDSDK_API_ENDPOINT_OVERRIDES_GKEMULTICLOUD=$1 gcloud container aws node-pools create $2 \
  --cluster=$3 \
  --location=$4 \
  --node-version=$5 \
  --config-encryption-kms-key-arn=$6 \
  --iam-instance-profile=$7 \
  --subnet-id=$8 \
  --min-nodes=3 --max-nodes=5 --max-pods-per-node=110

