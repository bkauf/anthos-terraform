#!/bin/bash

gcloud container aws clusters delete $2 \
  --location=$3 \
  --quiet