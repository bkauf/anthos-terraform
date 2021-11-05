# Anthos GKE on AWS Terraform


1. Enalbe GCP services on GCP

Create a PROJECT_ID variable
```
export PROJECT_ID=[gcp project ID]
```
Enable relevant Anthos APIs in this project

```
gcloud --project=${PROJECT_ID} services enable \
gkemulticloud.googleapis.com \
anthos.googleapis.com \
gkehub.googleapis.com \
connectgateway.googleapis.com \
cloudresourcemanager.googleapis.com \
gkeconnect.googleapis.com
```

2. 
