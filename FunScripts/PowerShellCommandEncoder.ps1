#This script encodes a powershell command and runs it
$command = 'write-host "LOL"'
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$scriptStart = "powershell.exe -encodedCommand " 
$encodedCommand = [Convert]::ToBase64String($bytes)
$encodedCommand = $scriptStart + $encodedCommand
$encodedCommand | set-content ("C:\FilePath\Output.ps1")
#powershell.exe -encodedCommand dwByAGkAdABlAC0AaABvAHMAdAAgACIATABPAEwAIgA=