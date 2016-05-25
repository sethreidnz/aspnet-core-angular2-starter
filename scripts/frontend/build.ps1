param( 
[Parameter(Mandatory=$true)]
[string]$FrontendProjectName,

[Parameter(Mandatory=$true)]
[string]$BuildSourcesDirectory
)

cd $BuildSourcesDirectory/src/$FrontendProjectName
npm install
npm run build
cd $BuildSourcesDirectory