'This script obfuscates VBS scripts to protect intellectual property or prevent editing by unsophisticated users.
'In software development, obfuscation is the act of creating source or machine code that is difficult for humans or computers to understand.
'Keep in mind obfuscation is not secure and does not provide security like encryption algorithms do.
'When run provide it a path to a VBS script to obfuscate.
Randomize()
Set FSO = CreateObject("Scripting.FileSystemObject")
SourceFileName = Inputbox("Enter path of the VBS file to scramble: ")
Set Source = FSO.OpenTextfile(SourceFileName, 1)
Body = Source.ReadAll
Source.Close
Set Output  = FSO.CreateTextFile("Output.vbs", True)
Output.WriteLine "Execute(" & Obfuscate(Body) & ")"
Output.Close

Function Obfuscate(txt)
	Dim Switch, enc, i
	enc = ""
	For i = 1 To Len(txt)
	Switch = Int(2 * Rnd()) + 1
	Select Case Switch
		Case 1
		enc = enc & "Chr(" & IntegerBreak(Asc(Mid(txt, i, 1))) & ")&"
		Case 2
		enc = enc & "Chr((" & IntegerBreak(Asc(Mid(txt, i, 1))) & "))&"
	End Select
	Next
	Obfuscate = enc & "vbcrlf"
End Function

Public Function IntegerBreak(PickedInteger)
        Randomize()
        Dim Switch, Entropy, Result, Counter
		If PickedInteger < 50 Then
		Switch = Int(9 * Rnd()) + 1
		Else
		Switch = Int(8 * Rnd()) + 1
		End If
        'ration entropy
        If Switch = 3 Then 'multiplication
            Counter = 100
            For i = 0 To 100
                If PickedInteger Mod Counter = 0 And PickedInteger <> Counter Then
                    Entropy = Counter
                    Exit For
                End If
                Counter = Counter - 1
            Next
        ElseIf Switch = 7 Then 'exponents
            Entropy = Int(3 * Rnd()) + 1
        Else
            Entropy = Int(100 * Rnd()) + 1
        End If
        'pick an equation
        Select Case Switch
            Case 1
                'addition
				 Result = PickedInteger - Entropy	  
                 IntegerBreak = "&H" & Hex(Result) & "+&H" & Hex(Entropy)
            Case 2
                'subtraction
                 Result = PickedInteger + Entropy
				 IntegerBreak = "&H" & Hex(Result) & "-&H" & Hex(Entropy)
            Case 3
                'multiplication       
                Result = PickedInteger / Entropy
                IntegerBreak = "&H" & Hex(Result) & "*&H" & Hex(Entropy)
            Case 4
                'division
                Result = PickedInteger * Entropy
                IntegerBreak = "&H" & Hex(Result) & "/&H" & Hex(Entropy)
            Case 5
                'squares
                Result = PickedInteger ^ 2
                IntegerBreak = "Sqr(&H" & Hex(Result) & ")"
            Case 6
                'xor
                Result = PickedInteger Xor Entropy
                IntegerBreak = "(&H" & Hex(Result) & ")Xor(&H" & Hex(Entropy) & ")"
            Case 7
                'exponents
                Result = PickedInteger ^ Entropy
                IntegerBreak = Result & "^(&H1/&H" & Hex(Entropy) & ")"
            Case 8
                'hex
                IntegerBreak = "&H" & Hex(PickedInteger)
			Case 9
                'modulus 
                Result = PickedInteger + Entropy
                Counter = 100
                Do While Result Mod Entropy <> PickedInteger
                    Entropy = Int(100 * Rnd()) + 1
                    Result = PickedInteger + Entropy
                    Counter = Counter - 1
                Loop
                IntegerBreak = "(" & "&H" & Hex(Result) & ")Mod(" & "&H" & Hex(Entropy) & ")"
        End Select
End Function