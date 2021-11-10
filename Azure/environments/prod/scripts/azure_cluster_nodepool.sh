#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

gcloud alpha container azure node-pools create $1 \
  --cluster=$2 \
  --location $3 \
  --node-version=1.19.10-gke.1000 \
  --vm-size=Standard_D4s_v3 \
  --max-pods-per-node=110 \
  --min-nodes=1 \
  --max-nodes=2 \
  --ssh-public-key="$4" \
  --subnet-id="$5"

