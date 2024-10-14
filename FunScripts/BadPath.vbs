'This script creates an unbrowsable + undeletable illegal folder structure and puts a file inside it
'WARNING: Do not use this script, it could lead to data loss and more. Creating illegal folder structures can brick your computer and cause directory traversing applications to memory leak and crash. Windows Explorer can not navigate these folders. Turn back now.
'If you do continue you "might" be able to delete these folders with cmd.exe example:
'cd "C:\Users\userName\Desktop\"
'rmdir [tab]
'If not you may need to manually edit the drive with a special disk editing program like Hxd
'Working on Windows 7 and earlier
Dim oFSO, objNetwork, userName
Set objNetwork = CreateObject("Wscript.Network")
Set oFSO = CreateObject("Scripting.FileSystemObject")
userName = objNetwork.UserName
'Create Folder 1
oFSO.CreateFolder "C:\Users\" & userName & "\Desktop\BadPath\"
'Create Folder 2
oFSO.CreateFolder "C:\Users\" & userName & "\Desktop\BadPath\   \"
'Create Folder 3
oFSO.CreateFolder "C:\Users\" & userName & "\Desktop\BadPath\   \...\"
'Copy File
If oFSO.FileExists("C:\Users\" & userName & "\Desktop\FileName.txt") Then
oFSO.CopyFile "C:\Users\" & userName & "\Desktop\FileName.txt", "C:\Users\" & userName & "\Desktop\BadPath\   \...\FileName.txt"
End If