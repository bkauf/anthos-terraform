#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud container aws node-pools create $1 \
  --cluster=$2 \
  --location=$3 \
  --node-version=$4 \
  --config-encryption-kms-key-arn=$5 \
  --iam-instance-profile=$6 \
  --subnet-id=$7 \
  --min-nodes=3 --max-nodes=5 --max-pods-per-node=110

