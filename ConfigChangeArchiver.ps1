Start-Transcript -Path "C:\CustomScripts\ConfigChangeArchiver\ConfigChangeArchiverTranscript.txt"

$Todays = Get-ChildItem -Path "C:\Program Files (x86)\SolarWinds\Orion\NCM\Jobs\Daily Config Change Report.htm"
If (!(Test-Path "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\")) { New-Item -ItemType Directory -Path "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\" }
$NewestArchieved = Get-ChildItem -Path "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\" |
                   Where-Object { $_.Extension -eq ".htm" } | Sort-Object { $_.CreationTime } -Descending | Select-Object -First 1
If ($Todays.LastWriteTime -gt $NewestArchieved.LastWriteTime) { 
    Copy-Item $Todays.FullName -Destination "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\"
    Rename-Item "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\Daily Config Change Report.htm" -NewName "Daily Config Change Report-$(Get-Date -Format MMddyyyy_HHmmss).htm"            
}
#Delete any record in the DiskFreeSpaceCheck directory that is older than 14 days (except for the flagged nodes file, used for email tracking).
Get-ChildItem -Path "C:\CustomScripts\ConfigChangeArchiver\Daily Config Change Report Archive\" -Recurse -Force -ErrorAction Silent | 
Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt (Get-Date).AddDays(-730) } | 
Remove-Item -Force

Stop-Transcript