# This script uploads Intilecta validated CSV files to Te Puna / Pinga via the API for validation.
# The script will read files from a specified directory for uploading.  It will select files from 
# the directory with yesterday's date.
# It uses the CredentialManager module to retrieve API credentials stored in Windows Credential Manager.


# The script accepts the following parameters:
# -FilePath: The path to the CSV file to be uploaded.
# -StartDate: The start date for the file selection (default is yesterday).
# -EndDate: The end date for the file selection (default is today).
param (
    [string]$DirectoryPath = "C:\Users\andre\OneDrive - Castnet Consulting Limited\Clients\TeWhatuOra\Intilecta\",
    [datetime]$StartDate = (Get-Date).AddDays(-1).Date,
    [datetime]$EndDate = $StartDate.AddDays(1).AddSeconds(-1) # End of the day yesterday
)

# Load the config file
$configPath = ".\config.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json

Start-Transcript -Path $config.LogFilePath 

Write-Host "Uploading Intilecta files to Pinga API"
Write-Host "Directory Path: $DirectoryPath"
Write-Host "Start Date: $StartDate"
Write-Host "End Date: $EndDate"

Import-Module CredentialManager


# Retrieve the API key and secret from Windows Credential Manager
$apiKeyCredential = Get-StoredCredential -Target $config.ApiKeyName 
$apiSecretCredential = Get-StoredCredential -Target $config.ApiSecretName 

$apiKey = $apiKeyCredential.GetNetworkCredential().Password
$apiSecret = $apiSecretCredential.GetNetworkCredential().Password

# Write-Host "API Key: $apiKey"
# Write-Host "API Secret: $apiSecret"

# Get the list of files in the directory
$files = Get-ChildItem -Path $DirectoryPath -Filter "*.csv" | Where-Object { $_.LastWriteTime -ge $StartDate -and $_.LastWriteTime -le $EndDate }

# Iterate through the files and upload them
foreach ($file in $files) {
    Write-Host "Processing file: $($file.Name)"
    
    # Create the headers
    $headers = @{
        "x-api-key" = $apiKey
        "x-api-secret" = $apiSecret
    }
  

  # Create the multipart form data
  $form = @{
    csv = Get-Item -Path $file.FullName
  }  

  # Make the HTTP request
  Invoke-WebRequest -Uri $config.EndpointUrl -Method POST -Headers $Headers -Form $form

  # Output the response
  $response
}

Stop-Transcript