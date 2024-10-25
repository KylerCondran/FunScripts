'This script showcases how to use the Right-To-Left Override Character
'It is used for languages that are read right to left (such as Arabic or Hebrew)
'This script creates a file ending in a ".exe" extension that is actually a ".txt" file
'Right-To-Left Override Character = chrw(&H202E)
'Left-To-Right Override Character = chrw(&H202D)
'You can go forward and backwards at will to create some funny but still working file names
Dim FSO, FilePath, objNetwork, userName
Set FSO = CreateObject ("Scripting.FileSystemObject")
Set objNetwork = CreateObject("Wscript.Network")
userName = objNetwork.UserName
FilePath = "C:\Users\" & userName & "\Desktop\TextFile" & chrw(&H202E) & "exe.txt"
Set WriteFile = FSO.OpenTextFile(FilePath, 8, 1)
WriteFile.Write "This is a Text File LOL"
WriteFile.Close