# Connect to your azure account using a user that has sufficient permission to create resources within
# the subscription. A good practice is to create a Service Principal Name within the subscription,
# that is part of the Contributor role. You can then use its' details to also run AZ CLI commands
# via CICD pipelines for example.
# 
# You will need 4 parameters for logging in:
#
# TenantID - This will be your Azure Active Directory (AAD) Tenant that is connected to your subscription.
# ClientID - This will be the Service Principle (SPN) Client ID
# ClientSecret - This will be the Service Principle Secret (a.k.a. Password)
# SubscriptionID - This will be the Subscription ID where to create the resources
#
# We will create a dedicated Resource Group, in it create a Storage Account. Then retrieve one
# of the storage account access keys and use that to create a Storage Account Blob Container.
# This only needs to be executed once. The values you select, need to be saved in the Backend
# block of terraform, if you choose to execute the scripts manually. Please change the values
# used here as an example.

# Create a Resource Group. Customize the tags for cost management.
az group create --name myTFStateRG --location northeurope --tags Environment=myEnvironment Project=myProject CreatedBy=Manually

# Create a Storage Account. Customize the tags.
az storage account create --name myStorageAccount --resource-group myTFStateRG --location northeurope --sku Standard_LRS --encryption-services blob --allow-blob-public-access false --tags Environment=myEnvironment CreatedBy=Manually

# Get Storage Account Key
$ACCOUNT_KEY = $(az storage account keys list --resource-group myTFStateRG --account-name myStorageAccount --query [0].value -o tsv)

# Create a Container in the Storage Account
az storage container create --account-key $ACCOUNT_KEY --account-name myStorageAccount --name terraform