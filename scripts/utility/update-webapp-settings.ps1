# Usage: UpdateWebAppSettings -WebAppName $WebAppName -WebSlotName $WebSlotName -ResourceGroupName $ResourceGroupName -SettingsToUpdate $SettingsToUpdate
param(
    [Parameter(Mandatory=$true)]
	[string] $WebAppName,
    [Parameter(Mandatory=$true)]
	[string] $WebSlotName,
    [Parameter(Mandatory=$true)]
	[string] $ResourceGroupName,
	[Parameter(Mandatory=$true)]
	[hashtable] $SettingsToUpdate)

$SettingsToUpdateString = [string]($SettingsToUpdate.GetEnumerator() | % { "$($_.Key)=$($_.Value)`n" })
Write-Verbose "Updating the following settings to WebAppName='$WebAppName' WebSlotName='$WebSlotName': `n `n $SettingsToUpdateString" 

$WebApp = Get-AzureRMWebAppSlot -ResourceGroupName $ResourceGroupName -Name $WebAppName -Slot $WebSlotName
$oldSettings = $WebApp.SiteConfig.AppSettings

$newSettings = @{}
#create a hash containing all the old settings
ForEach ($kvp in $oldSettings) {
    $newSettings[$kvp.Name] = $kvp.Value
}

#copy the new settings into this (and override)
ForEach ($stu in $SettingsToUpdate.GetEnumerator()) {
    $newSettings[$stu.Name] = $stu.Value
}

if($oldSettings.count -ne $newSettings.count){
    throw "The new settings did not contain the same number of entries as the old settings. Aborting"
}

Set-AzureRMWebAppSlot -ResourceGroupName $ResourceGroupName -Name $WebAppName -AppSettings $newSettings -Slot $WebSlotName

Write-Host "Finished updating the following settings to WebAppName='$WebAppName' WebSlotName='$WebSlotName': `n`n $SettingsToUpdateString" -ForegroundColor Green
