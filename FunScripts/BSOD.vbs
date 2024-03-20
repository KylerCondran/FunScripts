'This script causes your computer to do a blue screen of death and restart
'useful for testing and troubleshooting, needs to be ran as an administrator
Dim aShell
Set aShell = CreateObject ("WScript.Shell")
aShell.run "powershell get-process | stop-process -force"
aShell.run "taskkill /IM mshta.exe"
Set aShell = Nothing