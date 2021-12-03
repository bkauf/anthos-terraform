#!/bin/bash

gcloud container aws clusters delete $1 \
  --location=$2 \
  --quiet