Start-Transcript -Append "C:\Discovery-$(date -Format yyyy-MM-dd_hh_mm_ss).txt"
Write-Host "********************************************************************************************"
Write-Host "*****************************Server Configration Details************************************"
Write-Host "********************************************************************************************"
Get-Date
#Write-Host"Hostname"
Write-Host "********************************************************************************************"
Write-Host "**************************************Server Hostname***************************************"
Write-Host " "
hostname
Write-Host " "
Write-Host "**************************************Doamin Name Details*******************************"
Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select Name, Domain
Write-Host " "
Write-Host "**************************************Ethernet details**************************************"
Get-NetIPAddress -AddressFamily IPv4  -InterfaceAlias Ethernet |Select IPAddress,InterfaceAlias
Write-Host "*******************************************************************************************"
Write-Host " "
Write-Host "**************************************Server IP Details*************************************"
(Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
Write-Host " "
Write-Host "**************************************Server Uptime*****************************************"
$uptime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime
"$($uptime.days) Days $($uptime.Hours) Hours and $($uptime.Minutes) Minutes"
Write-Host "********************************************************************************************"
Write-Host " "
Write-Host "**************************************Disk Details******************************************"
Get-PhysicalDisk | Format-Table -AutoSize
Write-Host " "
Write-Host "**************************************Free Space********************************************"
Get-WmiObject -Class win32_logicaldisk | Format-Table DeviceId, MediaType, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}
Write-Host " "
Write-Host "**************************************List All Disk*****************************************"
Get-Disk | Format-Table -AutoSize
Write-Host " "
Write-Host "**************************************Offline Disk******************************************"
Get-Disk | Where-Object IsOffline -eq $True
Write-Host " "
Write-Host "**************************************Operating System Name********************************"
(Get-WMIObject win32_operatingsystem).name; (Get-WmiObject Win32_OperatingSystem).CSName
Write-Host " "
Write-Host "**************************************Secure Boot Status***********************************"
Confirm-SecureBootUEFI
Write-Host " "
Write-Host "**************************************Total Disk Count*************************************"
(get-disk | select number, size).count
#Get-Disk |select number,size.count
Write-Host " "
Write-Host "**************************************Server OS Information**************************************"
$Computer = "localhost"
$wmi_os = Get-WmiObject -class Win32_OperatingSystem -ComputerName $Computer | select CSName,Caption,Version,OSArchitecture,LastBootUptime
$wmi_cpu = Get-WmiObject -class Win32_Processor -ComputerName $Computer | select -ExpandProperty DataWidth
$wmi_memory = Get-WmiObject -class cim_physicalmemory -ComputerName $Computer | select Capacity | %{($_.Capacity / 1024kb)}
Write-Host "Hostname from WMI`: $($wmi_os.CSName)"
Write-Host "$($wmi_os.Caption) $wmi_build $($wmi_os.OSArchitecture) $($wmi_os.Version)"
Write-Host "CPU Architecture: $wmi_cpu"
Write-Host "Memory: $wmi_memory"
Write-Host "*************************************************************************************************"
Write-Host " "
Write-Host "**************************************Firewall Status********************************************"
Get-NetFirewallProfile | Format-Table Name, Enabled
Write-Host " "
Write-Host "**************************************Process Details********************************************"
get-process | Format-Table -AutoSize
Write-Host " "
Write-Host "**************************************Total Process Count****************************************"
(get-process).count
Write-Host "*************************************************************************************************"
Write-Host " "
Write-Host "**************************************Running Service Count**************************************"
(Get-Service | Where-Object {$_.Status -eq "Running"}).count
Write-Host " "
Write-Host "**************************************Share Drive************************************************"
Get-PsDrive -PsProvider FileSystem | Format-Table -AutoSize
Write-Host " "
Write-Host "**************************************Software List ******************************************************"
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table
Write-Host " "
Write-Host " "
Write-Host "**************************************Running Service Details*******************************************************"
Write-Host " "
Get-Service | Where-Object {$_.Status -eq "Running"}

#Write-Host " "
#Write-Host " "

Write-Host "**************************************CPU & RAM Details*******************************************************"

Get-WmiObject –class Win32_processor | ft NumberOfCores,NumberOfLogicalProcessors | Format-Table;[Math]::Round((Get-WmiObject Class Win32_ComputerSystem).TotalPhysicalMemory/1GB)

#Write-Host " "
#Write-Host "**************************************Server Details has been Captured**************************************"
#Write-Host " "