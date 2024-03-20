'This script scans your computer for files that contain emails and adds them to a text file.
'Just change the FilePath variable to change the output location of the text file.
On Error Resume Next
Set FSO = CreateObject ("Scripting.FileSystemObject")
Set Dict = CreateObject("Scripting.Dictionary")
Dim FilePath 
FilePath = "C:\FilePath\emails.txt"
Set WriteFile = FSO.OpenTextFile(FilePath, 8, 1)
 
Set objRE = New RegExp 
objRE.Global = True
objRE.IgnoreCase = True
objRE.Pattern = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}"
 
For Each Drive In FSO.Drives
If Drive.IsReady = True And (Drive.DriveType = 2) Then
'Add more drive types to scan more types of drives
'If Drive.IsReady = True And (Drive.DriveType = 2 Or Drive.DriveType = 3) Then
For Each RootFile In FSO.GetFolder(Drive).Files
Select Case LCase(FSO.GetExtensionName(RootFile.Name))
Case "msg", "oft", "sht", "dbx", "tbb", "adb", "doc", "wab", "asp", "aspx", "uin", "rtf", "vbs", "html", "htm", "pl", "php", "txt", "eml", "csv", "hta"
ScanRoutine(RootFile.Path)
End Select
Next
Recurse(Drive)
End If
Next
Dim x
x = Dict.RemoveAll
WriteFile.Close
'------------------------------------------------------------------------------------
Sub Recurse(SomeFolder)
For Each FolderSet In FSO.GetFolder(SomeFolder).SubFolders
For Each FileSet In FSO.GetFolder(FolderSet).Files
Select Case LCase(FSO.GetExtensionName(FileSet.Name))
Case "msg", "oft", "sht", "dbx", "tbb", "adb", "doc", "wab", "asp", "aspx", "uin", "rtf", "vbs", "html", "htm", "pl", "php", "txt", "eml", "csv", "hta"
WriteFile.WriteLine Now & " " & FileSet.Path
ScanRoutine(FileSet.Path)
End Select
Next
Recurse(FolderSet)
Next
End Sub
'------------------------------------------------------------------------------------
Sub ScanRoutine(HostFile)
Set objTextFile = FSO.OpenTextFile(HostFile, 1)
  strText = objTextFile.ReadAll
  objTextFile.Close
  Dim oMTS : Set oMTS = objRE.Execute(strText)
  Dim oMT
  For Each oMT In oMTS
  If Dict.Exists(LCase(oMT.Value)) = False Then
  Dict.Add LCase(oMT.Value), ""
  End If
  Next
End Sub
'------------------------------------------------------------------------------------