param(
  [Parameter(Mandatory = $true)]
  [string] $Environment
)

Write-Host "Deploying to environment: $Environment"

# Replace this with your actual deployment logic based on environment
if ($Environment -eq "dev") {
  Write-Host "Performing deployment for dev environment..."
} elseif ($Environment -eq "prod") {
  Write-Host "Performing deployment for production environment..."
} else {
  Write-Warning "Unknown environment: $Environment"
}
