#Domain Generation Algorithms (DGA) are algorithms are used to periodically generate a large number of domain names that can be used as rendezvous points with their command and control servers.
function DGA($m, $d, $y)
{
$b = ""
$algorithm = [Security.Cryptography.HashAlgorithm]::Create("SHA1")
$a = "$m $d $y"
for($i=1; $i -le 16; $i++)
{
$fileBytes = ([system.Text.Encoding]::UTF8).getbytes($a)
$bytes = $algorithm.ComputeHash($fileBytes)
$a = -Join ($bytes | ForEach {"{0:x2}" -f $_})

$t = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
foreach ($let in $t.Split(",")) 
{
$a = $a -replace $let, ""
}

$a = $a.Substring(0,18)
$p = ($([int64]($a)) % 25) + 97
$b += $([char]($p))
}
return "https://$b.com/"
}

$r = get-date
for($i=1; $i -le 16; $i++)
{
DGA $([int]($r.Month)) $([int]($r.Day)) $([int]($r.Year))
$r = $r.AddDays(1)
}

start-sleep 120