Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile("C:\FilePath\List.txt", 1)
Dim U()
ReDim U(0)
Dim p
Dim strBuild
p = 0
strBuild = ""
Do While objFile.AtEndOfStream = False
	ReDim Preserve U(p)
    strLine = objFile.ReadLine
    U(p) = strLine
	p = p + 1
Loop

For i = 0 to (UBound(U) - 1)
For r = (i + 1) to (UBound(U) - 1)
If U(i) = U(r) Then
U(r) = ""
End If
Next
Next

Set WriteFile = objFSO.OpenTextFile("C:\FilePath\DeDuped.txt", 8, 1)
For z = 0 to UBound(U)
If U(z) <> "" Then
WriteFile.WriteLine U(z)
End If
Next
WriteFile.Close