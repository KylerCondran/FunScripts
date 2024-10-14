#This script retrieves a certificate from the certificate store by issuer
$validCerts = @(
    Get-ChildItem -Path Cert:\CurrentUser\My |
    Where-Object {
        $_.PrivateKey -is [System.Security.Cryptography.RSACryptoServiceProvider] -and
        $_.Issuer -eq "CN=CERTNAME"
    }
)
if ($validCerts.Count -eq 0)
{
    write-host "No RSA certificates with usable private keys were found in the current user's store."
	start-sleep 120
}
if ($validCerts.Count -eq 1)
{
    write-host "Certificate Found."
	$cert = $validCerts[0]
	$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
	$bytes = $cert.Export($type)
	[System.IO.File]::WriteAllBytes("C:\FilePath\FileName.cer", $bytes)
	start-sleep 120
}