#Uses a certificate from the microsoft certificate store, replace the zeros with the certificate identifier.
$cert = get-item -path cert:\currentuser\my\0000000000000000000000000000000000000000 -ea stop
#$password = ""
$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
$bytes = $cert.Export($type)
[System.IO.File]::WriteAllBytes("C:\FilePath\FileName.cer", $bytes)
#$error | Out-File "C:\FilePath\Errors.txt"
write-host "Done."
start-sleep 120