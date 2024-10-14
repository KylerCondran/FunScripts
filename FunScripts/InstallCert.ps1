#This script installs a certificate from a path
$pfxpath = "C:\FilePath\FileName.cer"
$password = ""
Add-Type -AssemblyName System.Security
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($pfxpath, $password, ‘Exportable’)

$store = Get-Item cert:\CurrentUser\My
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]"ReadWrite")
$store.add($cert)
$store.Close()
#$error | Out-File "C:\FilePath\Errors.txt"
write-host "Done."
start-sleep 120