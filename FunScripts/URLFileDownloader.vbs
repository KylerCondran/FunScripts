'This script downloads a list of file URL's line by line from a text file.
'Works great with an extension like 'Link Gopher' which pulls URL's from webpages.
Set fso=CreateObject("Scripting.FileSystemObject")

filename = "list.txt"
listFile = fso.OpenTextFile(filename).ReadAll
listLines = Split(listFile, vbCrLf)
i = 0

For Each line In listLines
dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")
dim bStrm: Set bStrm = createobject("Adodb.Stream")
Dim derp: Set derp = CreateObject("Scripting.FileSystemObject")
xHttp.Open "GET", line, False
xHttp.Send
with bStrm
    .type = 1 
    .open
    .write xHttp.responseBody
    .savetofile CStr(i) & "." & derp.GetExtensionName(line), 2 
end with
   i = i + 1
Next