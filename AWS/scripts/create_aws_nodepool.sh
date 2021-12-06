#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud container aws node-pools create $1 \
  --cluster=$2 \
  --location=$3 \
  --instance-type=${8} \
  --node-version=$4 \
  --config-encryption-kms-key-arn=$5 \
  --iam-instance-profile=$6 \
  --subnet-id=$7 \
  --tags="Name=${1}-np" \
  --min-nodes=1 --max-nodes=3 --max-pods-per-node=110

