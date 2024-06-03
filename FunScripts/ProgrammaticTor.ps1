#$ErrorActionPreference = 'SilentlyContinue'
$ToolsPath = split-path -parent $MyInvocation.MyCommand.Definition
$ErrorPath = Join-Path $ToolsPath 'Errors.txt'
$ResponsePath = Join-Path $ToolsPath 'Response.txt'
$Tor = Join-Path $ToolsPath 'tor.exe'
$Polipo = Join-Path $ToolsPath 'polipo.exe'
$WebClient = New-Object Net.WebClient
$TorRoamingLog = Join-Path $ToolsPath 'RoamingLog.txt'
Start-Process $Tor -ArgumentList " --Log `"notice file $TorRoamingLog`"" -WindowStyle Hidden
do
{
    Start-Sleep 1
    $LogContents = Get-Content $TorRoamingLog
}
while (!($LogContents -match 'Bootstrapped 100%: Done.'))
Start-Process $Polipo -ArgumentList 'socksParentProxy=localhost:9050' -WindowStyle Hidden
Start-Sleep 7
$WebProxy = New-Object Net.WebProxy('localhost:8123')
$WebProxy.UseDefaultCredentials = $True
$WebClient.Proxy = $WebProxy
$MyUri = 'https://website.com/filename.txt'
while (!$MyResponse)
{
    $MyResponse=$WebClient.DownloadString($MyUri)
}
$MyResponse | Out-File $ResponsePath
$error | Out-File $ErrorPath
write-host "Done."
start-sleep 120