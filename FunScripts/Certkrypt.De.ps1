#This is a PowerShell script that traverses your computers drives and decrypts files.
#It decrypts a randomly generated key at the start of each file with a private key certificate.
#This means the symmetric keys will be different for every file.
#The key appended to the start of each file is used to perform the symmetric decryption and decrypt the rest of the file with Rijndael Managed.
#The private key certificate is used to decrypt the encrypted key at the start of each file, then that decrypted key is used to decrypt the rest of the file.
#This is asymmetric decryption blended with symmetric decryption.
#This is the decryption algorithm, the encryption algorithm will be in another file.
#Warning: Be careful using this script, it could lead to data loss and more.
[Reflection.Assembly]::LoadWithPartialName("System.Security")  

#Decryption routine:
function Decrypt($path)
{
$item = [System.IO.File]::ReadAllBytes($path)
$enckey = @(0) * (256)
$encdata = @(0) * ($item.Length - 256)
[array]::Copy($item, 0, $enckey, 0, 256)
[array]::Copy($item, 256, $encdata, 0, $item.Length - 256)
$init = "init"
$r = new-Object System.Security.Cryptography.RijndaelManaged 
$r.Key = $cert.PrivateKey.Decrypt($enckey, $true)
$r.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($init))[0..15] 
$r.padding = "PKCS7"
$r.mode = "CBC"
$c = $r.createdecryptor()
$ms = new-Object IO.MemoryStream 
$cs = new-Object Security.Cryptography.CryptoStream $ms, $c, "Write" 
$cs.write($encdata, 0, $encdata.length)
$cs.close()
$ms.close()
$r.clear()
[System.IO.File]::WriteAllBytes($path, $ms.toarray())
}
#Start of PowerShell script.
cls
cd c:\
write-host "Working . . ."
#Uses a certificate from the microsoft certificate store, replace the zeros with the private key certificate identifier.
$cert = get-item -path cert:\currentuser\my\0000000000000000000000000000000000000000 -ea stop
$ErrorActionPreference = "SilentlyContinue"
$user = [environment]::machinename+"\"+[environment]::username

foreach ($n in get-wmiobject win32_logicaldisk -filter "drivetype='3' or drivetype='4'" | select-object -expandproperty name)
{ 
#Only decrypt *.encrypted files.
foreach ($i in get-childitem $n -r -i @("*.encrypted") | select-object -expandproperty fullname)
{
#Only decrypts files less than 180 mb, can change depending on your available resources.
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
#Do the decryption and rename.
Decrypt $i
[gc]::Collect()
$name = [System.IO.Path]::GetFileName($i)
$name = $name -replace ".encrypted", ""
rename-item $i $name
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