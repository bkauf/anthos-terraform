#!/bin/bash

env CLOUDSDK_API_ENDPOINT_OVERRIDES_GKEMULTICLOUD=$1 gcloud container aws clusters delete $2 \
  --location=$3 \
  --quiet