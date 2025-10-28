# Description: This script reads dividend data from a CSV file, provided you have a column named "Symbol" and "Value" that tracks dividend payments, aggregates the total dividends per stock ticker, and stores the results in a JSON file.
$jsonPath = "DATA.JSON"
$csvPath = "dividends.csv"
function Count-Dividends {

if (!(Test-Path -Path $jsonPath)) {	
	$emptyArray = "[" + [Environment]::NewLine + [Environment]::NewLine + "]"
	Set-Content -Path $jsonPath -Value $emptyArray -Encoding UTF8
}
$input = Get-Content -Path $jsonPath -Raw
$storedData = $input | ConvertFrom-Json

# Import the CSV file
$data = Import-Csv -Path $csvPath
$overallValue = 0

foreach ($row in $data) {
    $symbol = $row.Symbol
    $value  = [decimal]$row.Value
	$value = [Math]::Round($value, 2)
	$overallValue += $value
	$existingStock = $storedData | Where-Object { $_.Ticker -eq $symbol }
	if ($existingStock) {
		($storedData | Where-Object { $_.Ticker -eq $symbol }).Total += $value
	} else {
		$newStock = [PSCustomObject]@{
			Ticker                = $symbol
			Total                 = $value
		}
		$storedData += $newStock
	}
}

$storedData | ConvertTo-Json -Depth 3 | Out-File -FilePath $jsonPath -Encoding utf8
Write-Host "A grand total of $overallValue"
}
Count-Dividends