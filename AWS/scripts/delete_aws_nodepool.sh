#!/bin/bash

 gcloud container aws node-pools delete $1 \
  --cluster=$2 \
  --location=$3 \
  --quiet

