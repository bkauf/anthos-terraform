#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud container azure node-pools create $1 \
  --cluster=$2 \
  --location $3 \
  --node-version=1.21.5-gke.2800 \
  --vm-size=Standard_B2s \
  --max-pods-per-node=110 \
  --min-nodes=1 \
  --max-nodes=3 \
  --ssh-public-key="$4" \
  --subnet-id="$5" \
  --tags "google=$1-np"