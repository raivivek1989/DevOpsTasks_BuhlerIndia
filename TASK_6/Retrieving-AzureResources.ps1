# Set your Azure subscription, connection and Function App details
$azureAppSecret = "<Secret>"
$azureAppId = "b454ca51-f5d8-450f-8aa9-43ab8625c8b9"
$azureTenantID = "4d6cfffb-25e2-4840-bd3e-79653f699dd8"
$subscriptionId = "c16bfc63-6242-43bb-a12d-de7071024f81"

$storageName = "storageaccount00x"
$containerName = "resources-data"
$resourceGroupName = "rg_BuhlerInterviewTask"

# Setting error action as we are not using try catch
$ErrorActionPreference = "Stop"

# Connect Azure Function
$credential = New-Object System.Management.Automation.PSCredential ($azureAppId, (ConvertTo-SecureString $azureAppSecret -AsPlainText -Force))
Connect-AzAccount -ServicePrincipal -Tenant $azureTenantID -Subscription $subscriptionId -Credential $credential

# Fetching Azure resources, sort and convert to json
Write-Host "Fetching Azure resources data - Start"
$resourcesInJson = Get-AzResource | Sort-Object -Property ResourceType | ConvertTo-Json -Depth 10
Write-Host "Fetching Azure resources data - Completed"

# Create a temporary file
$tempFilePath = [System.IO.Path]::GetTempFileName() + ".json"
Set-Content -Path $tempFilePath -Value $resourcesInJson

# fetch destination storage account
Write-Host "Getting $storageName storage account details - Start"
$storage = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
Write-Host "Getting $storageName storage account details - End"

# create a container
Write-Host "Creating storage Container"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
New-AzStorageContainer -Name $containerName-$timestamp -Context $storage.Context
Write-Host "New container is created"

# Uploading json file
Write-Host "Pushing Azure data to container"
Set-AzStorageBlobContent -File $tempFilePath -Container $containerName-$timestamp -Context $storage.Context -Force
Write-Host "JSON Data Successfully uploaded"