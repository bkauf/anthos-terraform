#!/bin/bash

env CLOUDSDK_API_ENDPOINT_OVERRIDES_GKEMULTICLOUD=$1 gcloud container aws node-pools delete $2 \
  --cluster=$3 \
  --location=$4 \
  --quiet

