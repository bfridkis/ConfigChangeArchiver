$Todays = Get-ChildItem -Path "C:\Program Files (x86)\SolarWinds\Orion\NCM\Jobs\Daily Config Change Report.htm"
$NewestArchieved = Get-ChildItem -Path "C:\Program Files (x86)\SolarWinds\Orion\NCM\Jobs\Daily Config Change Report Archive" |
                   Where-Object { $_.Extension -eq ".htm" } | Sort-Object { $_.CreationTime } -Descending | Select-Object -First 1
If ($Todays.LastWriteTime -gt $NewestArchieved.LastWriteTime) { 
    Copy-Item $Todays.FullName -Destination "C:\Program Files (x86)\SolarWinds\Orion\NCM\Jobs\Daily Config Change Report Archive\"
    Rename-Item "C:\Program Files (x86)\SolarWinds\Orion\NCM\Jobs\Daily Config Change Report Archive\Daily Config Change Report.htm" -NewName "Daily Config Change Report-$(Get-Date -Format MMddyyyy_HHmmss).htm"            
}
