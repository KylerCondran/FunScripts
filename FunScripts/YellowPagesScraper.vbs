'This script scrapes the yellow pages for businesses and phone numbers of a specified category.
'Just change the FilePath variable to change the output location of the text file.
'Also change the website query string to change categories, may need editing if they have updated their website.
On Error Resume Next
Dim arrName(), arrPhone()
ReDim arrName(0), arrPhone(0)
Dim fullList, objHttp, output, oMTS, oMT, i
Set objRE = New RegExp 
Dim FilePath 
FilePath = "C:\FilePath\output.txt"
Set FSO = CreateObject ("Scripting.FileSystemObject")
Set WriteFile = FSO.OpenTextFile(FilePath, 8, 1)
Set objHttp = CreateObject("Microsoft.XMLHTTP")
'-----------------------------------------------------------------------------------|
ScanWebsite "http://411.ca/search/?q=computer&st=business"
ScrapeRoutine "<meta itemprop=""name"".+","Name"
ScrapeRoutine "<meta itemprop=""telephone"".+","Phone"
Write
WriteFile.Close
'-----------------------------------------------------------------------------------|
Sub ScanWebsite(ScanPage)
objHttp.Open "GET", ScanPage, False
objHttp.Send
output = objHttp.ResponseText
Set objHttp = Nothing 
End Sub
'-----------------------------------------------------------------------------------|
Sub Write()
For z = 0 to UBound(arrName)
fullList = fullList & arrName(z) & ":" & arrPhone(z) & vbCrLf
Next
fullList = Replace(fullList, "<meta itemprop=""name"" content=""", "USE Database INSERT INTO Table (Name,Phone) VALUES('")
fullList = Replace(fullList, """/>:<meta itemprop=""telephone"" content=""", "','")
fullList = Replace(fullList,"""/>","')")
WriteFile.WriteLine fullList
End Sub
'-----------------------------------------------------------------------------------|
Sub ScrapeRoutine(regEx,dataType)
i = 0
objRE.Pattern = regEx
objRE.Global = True 
objRE.IgnoreCase = True
Set oMTS = objRE.Execute(output)
For Each oMT In oMTS
If dataType = "Name" Then
ReDim Preserve arrName(i)
arrName(i) = oMT.Value
i = i + 1
ElseIf dataType = "Phone" Then
ReDim Preserve arrPhone(i)
arrPhone(i) = oMT.Value
i = i + 1
End If
Next
End Sub
'-----------------------------------------------------------------------------------|