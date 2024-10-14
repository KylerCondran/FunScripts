#This script makes 35 random pitch PowerShell console beeps
190..8500 | Get-Random -Count 35 | ForEach {[console]::Beep($_, 150)}