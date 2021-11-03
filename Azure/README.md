# GKE on Azure Terraform

## Prerequisites

1. Run  this terraform
```
terraform init
teffaform apply
```

2. Collect the output variables in the 'anthos-params.json' and put them into the following envoirnmental variables
```
  export APPLICATION_ID = [fill in]
  export CLUSTER_RG_ID = [fill in]
  export VNET_ID = [fill in]
  export CLUSTER_NAME = [fill in]
  export SUBNET_ID = [fill in]
  export TENANT_ID = [fill in]
  export AZURE_CLIENT = [fill in]
  export GCP_PROJECT_ID = [fill in]
  ```

 3. Enable the GCP APIs
 ```
gcloud services enable gkemulticloud.googleapis.com
gcloud services enable anthos.googleapis.com
gcloud services enable gkeconnect.googleapis.com
```

If this is the first cluster that you create in your Google Cloud project, you need to add an Identity and Access Management (IAM) policy binding to a Google Cloud service account.

 WILL NOT NEED THIS IN GA

```
gcloud projects add-iam-policy-binding "$GCP_PROJECT_ID" \
--member="serviceAccount:$GCP_PROJECT_ID.svc.id.goog[gke-system/gke-multicloud-agent]" \
--role="roles/gkehub.connect"
```


4. Create the Azure Client in GCP


```
gcloud alpha container azure clients create ${AZURE_CLIENT} \
  --location=${GCP_REGION} \
  --tenant-id="${TENANT_ID}" \
  --application-id="${APPLICATION_ID}"
```

5. Get the Azure cert from GCP and then put into into Azure AD

```
AZURE_CLIENT_CERT=$(gcloud alpha container azure clients get-public-cert --location=${GCP_REGION} ${APP_NAME})
```

```
az ad app credential reset --id "${APPLICATION_ID}" --cert "${AZURE_CLIENT_CERT}" --append
```

6. Geneate a key to use with the cluster

```
ssh-keygen -t rsa -b 4096 \
-C "${USER}" \
-N '' \
-f ${WORKDIR}/anthos-ssh-key
```


```
export SSH_PUBLIC_KEY=$(cat ${WORKDIR}/anthos-ssh-key.pub)
```

6. Create your cluster

# Control Plane
```
gcloud alpha container azure clusters create azure-cluster-2 \
  --location us-east4 \
  --client "$AZURE_CLIENT" \
  --azure-region "$AZURE_REGION" \
  --pod-address-cidr-blocks 10.100.0.0/22 \
  --service-address-cidr-blocks 10.200.0.0/22 \
  --vm-size Standard_B2s \
  --cluster-version 1.19.10-gke.1000 \
  --ssh-public-key "$SSH_PUBLIC_KEY" \
  --resource-group-id "$CLUSTER_RG_ID" \
  --vnet-id "$VNET_ID" \
  --subnet-id "$SUBNET_ID"
  ```
# Node Pool

gcloud alpha container azure node-pools create np-1 \
  --cluster=azure-cluster-2 \
  --location ${GCP_REGION} \
  --node-version=1.19.10-gke.1000 \
  --vm-size=Standard_D4s_v3 \
  --max-pods-per-node=110 \
  --min-nodes=1 \
  --max-nodes=2 \
  --ssh-public-key="${SSH_PUBLIC_KEY}" \
  --subnet-id="${SUBNET_ID}"



### Extra

# Setup a Bastion Host

az vm create \
  --resource-group "${AZURE_VNET_RESOURCE_GROUP}" \
  --location "${AZURE_REGION}" \
  --vnet-name "${AZURE_VNET}" \
  --ssh-key-values ${WORKDIR}/anthos-ssh-key.pub \
  --name anthos-bastion-host \
  --image UbuntuLTS \
  --size Standard_B1ls \
  --public-ip-sku Standard \
  --nsg ${anthos-bastion-host} \
  --nsg-rule SSH \
  --subnet ${SUBNET_ID} \
  --custom-data customdata.sh


# Get IP Address


```
export AZURE_BASTION_IP_ADDRESS=$(az network public-ip show \
  --resource-group ${AZURE_VNET_RESOURCE_GROUP} \
  --name ${AZURE_BASTION_VM}PublicIP --query "ipAddress" --output tsv)
echo -e "export AZURE_BASTION_IP_ADDRESS=${AZURE_BASTION_IP_ADDRESS}" | tee -a ${WORKDIR}/vars.sh && source ${WORKDIR}/vars.sh
```


#