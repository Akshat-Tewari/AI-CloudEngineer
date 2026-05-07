#!/bin/bash

RG="rg-ai-infra-phase1"
LOC="eastus"

echo "Checking if Resource Group exists..."
if [ $(az group exists --name $RG) = false ]; then
    az group create --name $RG --location $LOC
fi

# Try to find an existing storage account in this RG
EXISTING_ST=$(az storage account list --resource-group $RG --query "[0].name" -o tsv)

if [ -z "$EXISTING_ST" ]; then
    echo "No storage account found. Generating new name..."
    ST_NAME="staiinfra$(date +%s)" 
    echo "Creating Storage Account"
    az storage account create \
        --name $ST_NAME \
        --resource-group $RG \
        --location $LOC \
        --sku Standard_LRS \
        --kind StorageV2 \
        --access-tier Hot
else
    echo "Found existing storage account: $EXISTING_ST"
    ST_NAME=$EXISTING_ST
fi

# file share name
SHARE_NAME="ai-datasets"

echo "Creating File Share..."
# Check if the share exists to avoid 'AlreadyExists' errors in logs
SHARE_EXISTS=$(az storage share exists --name $SHARE_NAME --account-name $ST_NAME --query exists)

if [ "$SHARE_EXISTS" = "false" ]; then
    az storage share create --name $SHARE_NAME --account-name $ST_NAME --quota 1
    echo "Share created."
else
    echo "Share already exists, skipping."
fi

echo "Enabling Soft Delete..."
az storage account file-service-properties update \
    --account-name $ST_NAME \
    --resource-group $RG \
    --enable-delete-retention true \
    --delete-retention-days 7

# Create a dummy file to upload
echo "This is a sample AI dataset file." > sample_data.txt

# Check if the file already exists in the share before uploading & snapshotting
FILE_EXISTS=$(az storage file exists --account-name $ST_NAME --share-name $SHARE_NAME --path "sample_data.txt" --query exists)

if [ "$FILE_EXISTS" = "false" ]; then
    echo "Uploading file to Azure..."
    az storage file upload --account-name $ST_NAME --share-name $SHARE_NAME --source "sample_data.txt"
    
    echo "Creating Snapshot of initial upload..."
    az storage share snapshot --account-name $ST_NAME --name $SHARE_NAME
else
    echo "File already exists. Skipping upload and snapshot to save costs."
fi