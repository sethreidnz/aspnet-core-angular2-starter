param( 
[Parameter(Mandatory=$true)]
[string]$projectName,

[Parameter(Mandatory=$true)]
[string]$solutionRootDirectory,

[Parameter(Mandatory=$true)]
[string]$publishTargetDirectory
)

Write-Host "Start building project '$projectName' from source directory '$solutionRootDirectory\src\$projectName'" -ForegroundColor Green -Verbose;

$projectDirectory = "$solutionRootDirectory\src\$projectName";

if((Test-Path $projectDirectory) -ne $true){
    throw "Could not find project in directory '$projectDirectory'";
}

if((Test-Path $publishTargetDirectory) -ne $true){
    mkdir $publishTargetDirectory;
}

Get-ChildItem -Path $publishTargetDirectory -Include *.* -File -Recurse | foreach { $_.Delete()}

#Create the logs directory
mkdir "$publishTargetDirectory/logs"

dotnet publish $projectDirectory -o $publishTargetDirectory;

Write-Host "Finished building project '$projectName' from source directory '$solutionRootDirectory\src\$projectName'" -ForegroundColor Green -Verbose;