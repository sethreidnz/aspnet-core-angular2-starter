
#Usage: ./deploy/deploy.ps1 -WebAppName webappName -WebSlotName webslotName -ResourceGroup resourceGroupName -StorageAccountName storageContainer  -StorageAccountKey storageKey -StorageContainerName containerName -MainHashSettingString settingsString  -VendorHashSettingString settingsString  -PolyfillsHashSettingString settingsString -ChunkHashSettingString settingsString -BuildSourcesDirectory buildDirectory
param( 
    
[Parameter(Mandatory=$true)]
[string]$WebAppName,
    
[Parameter(Mandatory=$true)]
[ValidateSet("development", "staging", "production")]
[string]$WebSlotName,

[Parameter(Mandatory=$true)]
[string]$ResourceGroup,

[Parameter(Mandatory=$true)]
[string]$StorageAccountName,

[Parameter(Mandatory=$true)]
[string]$StorageAccountKey,

[Parameter(Mandatory=$true)]
[string]$StorageContainerName,

[Parameter(Mandatory=$true)]
[string]$MainHashSettingString,

[Parameter(Mandatory=$true)]
[string]$VendorHashSettingString,

[Parameter(Mandatory=$true)]
[string]$PolyfillsHashSettingString,

[Parameter(Mandatory=$true)]
[string]$ChunkHashSettingString,

[Parameter(Mandatory=$true)]
[string]$BuildSourcesDirectory
)
$updateWebAppSettingsScript = "$PSScriptRoot\update-webapp-settings.ps1"

Write-Host "Begining deployment to WebAppName : '$WebAppName' WebSlotName '$WebSlotName'"

function CopyAzureStorage ($sourcePath, $blobName, $storageContainerName, $storageContext)
{
  Write-Host "Copying files to azure storage: sourcePath: '$sourcePath' blobName: '$blobName'"
  $properties = @{}
  $properties["cacheControl"] = "public, max-age=31536000, must-revalidate"
  $properties["contentType"] = "javascript/x-application"
  Set-AzureStorageBlobContent -File $sourcePath -Container $storageContainerName -Blob $blobName -Context $storageContext -Force -Properties $properties
  Write-Host "Finished copying files to azure storage: sourcePath: '$sourcePath' blobName: '$blobName'"
}

Write-Host "Getting blob context for storage account: '$StorageAccountName' with key: '$StorageAccountKey'"

$currentDate = Get-Date
$distFolder = "$($BuildSourcesDirectory)/dist"

$mainJs = "$($distFolder)/main.bundle.js"
$vendorJs =      "$($distFolder)/vendor.bundle.js"
$polyfillsJs = "$($distFolder)/polyfills.bundle.js"
$chunkJs = "$($distFolder)/1.chunk.js"

if(((Test-Path $mainJs) -or (Test-Path $vendorJs)) -eq $false ){
    Throw "Could not find one or more of source files: '$($mainJs)' '$($vendorJs)'"
}

$mainHash = (Get-FileHash $mainJs -Algorithm MD5).Hash
$vendorHash = (Get-FileHash $vendorJs -Algorithm MD5).Hash
$polyfillsHash = (Get-FileHash $polyfillsJs -Algorithm MD5).Hash
$chunkHash = (Get-FileHash $chunkJs -Algorithm MD5).Hash

$mainJsBlobName = "$($mainHash)\main.bundle.js"
$vendorJsBlobName = "$($vendorHash)\vendor.bundle.js"
$polyfillsJsBlobName = "$($polyfillsHash)\polyfills.bundle.js"
$chunkJsBlobName = "$($chunkHash)\1.chunk.js"

$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

if($storageContext -eq $null){
    Throw "Call to New-AzureStorageContext with StorageAccountName: '$StorageAccountName' returned null"
}

CopyAzureStorage $mainJs $mainJsBlobName $storageContainerName $storageContext
CopyAzureStorage $vendorJs $vendorJsBlobName $storageContainerName $storageContext
CopyAzureStorage $polyfillsJs $polyfillsJsBlobName $storageContainerName $storageContext
CopyAzureStorage $chunkJs $chunkJsBlobName $storageContainerName $storageContext

$settingsToUpdate = @{
    $MainHashSettingString = $mainHash;
    $VendorHashSettingString = $vendorHash;
    $PolyfillsHashSettingString = $polyfillsHash;
    $ChunkHashSettingString = $chunkHash;
}

. $updateWebAppSettingsScript -WebAppName $WebAppName -WebSlotName $WebSlotName -ResourceGroupName $ResourceGroup -SettingsToUpdate $settingsToUpdate
    
Restart-AzureWebsite -Name $WebAppName -Slot $WebSlotName

Try{
	Invoke-RestMethod -Uri "https://app-propertyplot-$WebSlotName.azurewebsites.net"
}
Catch{

}