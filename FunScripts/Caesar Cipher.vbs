'The Caesar Cipher, used by Julius Caesar around 58 BC, is a substitution cipher that 
'shifts letters in a message to make it unreadable if intercepted. 
'To decrypt, the receiver reverses the shift.
Sub CaesarCipher(CipherText)
	Dim o 
	Dim v
	Dim StringRet
	o = "rfjznadeiowq21g.57kx-vtplc6s4/:8mhby390u "       
	v = "8of2g0qpiwrvlcky-zj5aedh39t17m4/nb.6xu:s "
	StringRet = ""
	For i = 1 To Len(CipherText)
		StringRet = StringRet & Mid(o,InStr(v,Mid(CipherText, i, 1)), 1)
	Next
	MsgBox(StringRet)
End Sub
CaesarCipher("9wqigk i1 osg")