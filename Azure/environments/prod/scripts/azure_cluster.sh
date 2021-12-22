#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud container azure clusters create $1 \
  --location $2 \
  --client "$3" \
  --azure-region "$4" \
  --pod-address-cidr-blocks 10.100.0.0/22 \
  --service-address-cidr-blocks 10.200.0.0/22 \
  --vm-size Standard_B2s \
  --cluster-version 1.21.5-gke.2800 \
  --ssh-public-key "$5" \
  --resource-group-id "$6" \
  --vnet-id "$7" \
  --subnet-id "$8" \
  --fleet-project "$9" \
  --tags "google=$1-cp"

