param( 
[Parameter(Mandatory=$true)]
[string]$FrontendProjectName,

[Parameter(Mandatory=$true)]
[string]$BackendProjectName,

[Parameter(Mandatory=$true)]
[string]$BuildSourcesDirectory
)

$frontendBuildScript = "$BuildSourcesDirectory\scripts\frontend\build.ps1"
. $frontendBuildScript -FrontendProjectName $FrontendProjectName -BuildSourcesDirectory $BuildSourcesDirectory


