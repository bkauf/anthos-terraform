#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud alpha container azure clusters create $1 \
  --location $2 \
  --client "$3" \
  --azure-region "$4" \
  --pod-address-cidr-blocks 10.100.0.0/22 \
  --service-address-cidr-blocks 10.200.0.0/22 \
  --vm-size Standard_B2s \
  --cluster-version 1.19.10-gke.1000 \
  --ssh-public-key "$5" \
  --resource-group-id "$6" \
  --vnet-id "$7" \
  --subnet-id "$8"
