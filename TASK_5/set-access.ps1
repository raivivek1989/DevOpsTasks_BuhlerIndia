$azureAppSecret = "<secret>"
$azureAppId = "b454ca51-f5d8-450f-8aa9-43ab8625c8b9"
$azureTenantID = "4d6cfffb-25e2-4840-bd3e-79653f699dd8"
$subscriptionId = "c16bfc63-6242-43bb-a12d-de7071024f81"
$displayName = "George"
$resourceGroupName = "rg_BuhlerInterviewTask"
$AppName = "TestApplicationxy"

$ErrorActionPreference = "Stop"

# Connect Azure Function
$credential = New-Object System.Management.Automation.PSCredential ($azureAppId, (ConvertTo-SecureString $azureAppSecret -AsPlainText -Force))
Connect-AzAccount -ServicePrincipal -Tenant $azureTenantID -Subscription $subscriptionId -Credential $credential

# Get the user object based on display name
$user = get-AzADUser | Where-Object{$_.DisplayName -eq "George"}

if ($null -eq $user) {
    Write-Host "User with display name '$displayName' not found."
    exit
}

# Get the Function App
$functionApp = Get-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $AppName -Verbose

if ($null -eq $functionApp) {
    Write-Host "Function App '$AppName' not found in resource group '$resourceGroupName'."
    exit
}

# Assign the Contributor role to the user for the Function App
New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName "Contributor" -Scope $functionApp.Id -Verbose

Write-Host "Contributor access has been granted to user '$displayName' for the Function App '$AppName'."