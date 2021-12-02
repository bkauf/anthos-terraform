#!/bin/bash

 gcloud container aws node-pools delete $2 \
  --cluster=$3 \
  --location=$4 \
  --quiet

