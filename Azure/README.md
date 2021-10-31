# GKE on Azure Terraform

## Prerequisites

1. Run  this terraform
2. Collect the output variables in the 'anthos-params/json' and put them into the following envoirnmental variables
```
  export APPLICATION_ID = [fill in]
  export CLUSTER_RG_ID = [fill in]
  export VNET_ID = [fill in]
  export CLUSTER_NAME = [fill in]
  export SUBNET_ID = [fill in]
  export TENANT_ID = [fill in]
  export APP_CLIENT = [fill in]
  ```
3. Create the Azure Client in GCP

export AZURE_CLIENT = [name of Azure GCP Client]


```gcloud alpha container azure clients create ${AZURE_CLIENT} \
  --location=${AZURE_REGION} \
  --tenant-id="${TENANT_ID}" \
  --application-id="${APPLICATION_ID}"
  ```

4. Get the Azure cert from GCP and then put into into Azure AD

````
AZURE_CLIENT_CERT=$(gcloud alpha container azure clients get-public-cert --location=${AZURE__REGION} ${APP_NAME})
```


```
az ad app credential reset --id "${APPLICATION_ID}" --cert "${AZURE_CLIENT_CERT}" --append
```

5. Get the path of your public cert 
```
export SSH_PUBLIC_KEY=$(cat ${WORKDIR}/anthos-ssh-key.pub)
```

6. Create your cluster

gcloud alpha container azure clusters create [cluster name] \
  --location us-east4 \
  --client "$APP_CLIENT" \
  --azure-region "$AZURE_REGION" \
  --pod-address-cidr-blocks 10.100.0.0/22 \
  --service-address-cidr-blocks 10.200.0.0/22 \
  --vm-size Standard_B2s \
  --cluster-version 1.19.10-gke.1000 \
  --ssh-public-key "$SSH_PUBLIC_KEY" \
  --resource-group-id "$CLUSTER_RG_ID" \
  --vnet-id "$VNET_ID" \
  --subnet-id "$SUBNET_ID"
