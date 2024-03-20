#This PowerShell script fingerprints a Windows computer and saves the information to a text file.
#Just change the $SavePath variable to set your location to save the text file.
$WebClient = New-Object Net.WebClient
$GeographicRegion = $WebClient.DownloadString('http://ip-api.com/json/')
if(!$GeographicRegion) { $GeographicRegion = 0 }
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$OperatingSystem = Get-WmiObject Win32_OperatingSystem
$ComputerSystem = Get-WmiObject Win32_computersystem
$InstalledSoftware = Get-WmiObject -Class Win32_Product
$OSVersion = $OperatingSystem.Version
$OSArchitecture = $OperatingSystem.OSArchitecture
$Domain = $ComputerSystem.Domain
$IsDomainJoined = $ComputerSystem.PartOfDomain
$CultureInfo = [Globalization.Cultureinfo]::GetCultureInfo([Int] $OperatingSystem.OSLanguage).Name
$SavePath = "C:\FilePath\sysinfo.txt"

foreach ($SoftwarePackage in $InstalledSoftware)
{
    $SoftwareProduct += $SoftwarePackage.Name + '|' + $SoftwarePackage.Version + '||'
}

$Newline = [Environment]::NewLine

$SystemInfo = 'geodata=' + ($GeographicRegion) + $Newline +
              '&language=' + ($CultureInfo) + $Newline +
              '&isadmin=' + $IsAdmin + $Newline +
              '&win_version=' + ($OSVersion) + $Newline +
              '&domain=' + ($Domain) + $Newline +
              '&indomain=' + $IsDomainJoined + $Newline +
              '&os_arch=' + ($OSArchitecture)  + $Newline +
              '&softlist=' + ($SoftwareProduct)
			  
$SystemInfoBytes = [Text.Encoding]::ASCII.GetBytes($SystemInfo)

[System.IO.File]::WriteAllBytes($SavePath, $SystemInfoBytes)