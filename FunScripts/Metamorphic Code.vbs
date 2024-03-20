'Metamorphic code is code that when run outputs a logically equivalent version of its own code under some interpretation.
'Every time it is run it will have a different file signature when compared by hashing algorithms but will continue to function as intended.
Const ForReading = 1, ForWriting = 2
Randomize
Set FSO = CreateObject("Scripting.FileSystemObject")
Set ThisFile = FSO.OpenTextFile(Wscript.ScriptFullName, ForReading)
ThisCode = ThisFile.ReadAll
ThisFile.Close
Set ThisFile = FSO.OpenTextFile(Wscript.ScriptFullName, ForWriting, 1)
ThisFile.Write Mutate(ThisCode)
ThisFile.Close

Function Mutate(MutaString)
NewMutaString = ""
iCount = 1
While iCount <= Len(MutaString)
If Mid(MutaString, iCount, 1) = Chr(32) Then
NewMutaString = NewMutaString + Chr(32)
Do
iCount = iCount + 1
Loop While Mid(MutaString, iCount, 1) = Chr(32)
Else
If Int(2 * Rnd) + 1 = 1 Then
NewMutaString = NewMutaString + UCase(Mid(MutaString, iCount, 1))
Else
NewMutaString = NewMutaString + LCase(Mid(MutaString, iCount, 1))
End If
iCount = iCount + 1
End If
Wend
Mutate = NewMutaString
End Function