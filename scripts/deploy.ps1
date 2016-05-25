param( 
[Parameter(Mandatory=$true)]
[string]$FrontendProjectName,

[Parameter(Mandatory=$true)]
[string]$BuildSourcesDirectory,

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
[string]$ChunkHashSettingString
)

$frontendDeployScript = "$BuildSourcesDirectory\scripts\frontend\build.ps1"
. $frontendDeployScript -FrontendProjectName $FrontendProjectName -BuildSourcesDirectory $BuildSourcesDirectory

./deploy/deploy.ps1 -FrontendProjectName $FrontendProjectName -BuildSourcesDirectory $BuildSourcesDirectory -WebAppName $WebAppName -WebSlotName $WebSlotName -ResourceGroup $ResourceGroup -StorageAccountName $StorageContainerName -StorageAccountKey $StorageAccountKey -StorageContainerName containerName -MainHashSettingString settingsString  -VendorHashSettingString settingsString  -PolyfillsHashSettingString settingsString -ChunkHashSettingString settingsString

