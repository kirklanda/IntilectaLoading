# Define the file path
$filePath = "C:\Users\andre\OneDrive - Castnet Consulting Limited\Clients\TeWhatuOra\Intilecta\ZAA1322 - Claire Fraser.csv"

# Set the desired dates
(Get-Item $filePath).LastWriteTime = "2025-05-08 10:00:00"
(Get-Item $filePath).CreationTime = "2025-05-08 09:00:00"
(Get-Item $filePath).LastAccessTime = "2025-05-08 11:00:00"

# Verify the changes
Get-Item $filePath | Select-Object Name, CreationTime, LastWriteTime, LastAccessTime