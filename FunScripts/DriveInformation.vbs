'This script returns information for each drive in your computer and prints it to a text file.
'Just change the FilePath variable to change the output location of the text file.
On Error Resume Next
Set FSO = CreateObject ("Scripting.FileSystemObject")
Dim FilePath 
FilePath = "C:\FilePath\DriveInformation.txt"
Set TestFile = FSO.OpenTextFile(FilePath, 8, 1)
For Each Drive In FSO.Drives
If Drive.IsReady = True Then
TestFile.WriteLine "Available Space: " & Drive.AvailableSpace & " Drive Letter: " & Drive.DriveLetter & " Drive Type: " & Drive.DriveType & " File System: " & Drive.FileSystem & " Free Space: " & Drive.FreeSpace & " Is Ready: " & Drive.IsReady & " Path: " & Drive.Path & " Root Folder: " & Drive.RootFolder & " Serial Number: " & Drive.SerialNumber & " Share Name: " & Drive.ShareName & " Total Size: " & Drive.TotalSize & " Volume Name: " & Drive.VolumeName
End If
Next
TestFile.Close