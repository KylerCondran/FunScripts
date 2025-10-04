#This PowerShell script scans a list of stock tickers for end of day prices via an API and notifies the user if any current prices are below the set threshold.
$tickers = ""

#A list of stock tickers and their respective price limits that trigger alerts when the price falls below the specified value. Add or subtract tickers from this list.
$stocks = @{
    "RY.TO"   = 205.30
    "TD.TO"   = 100.50
    "ENB.TO"  = 75.10
    "BNS.TO"  = 85.60
    "SHOP.TO" = 220.40
}

foreach ($stock in $stocks.GetEnumerator()) {
    $tickers = $tickers + $stock.Key + ","
}

$tickers = $tickers.Substring(0, $tickers.Length - 1)

#Get an API key and plug it in here.
$api_key = "00000000000000000000000000000000"
$url = "https://api.marketstack.com/v2/eod/latest?access_key=$api_key&symbols=$tickers"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
$json = $response.Content | ConvertFrom-Json

$counter = 0

foreach ($stock in $stocks.GetEnumerator()) {
	$closingPrice = ($json.data | Where-Object { $_.symbol -eq $stock.Key }).close
	if ($closingPrice -lt $stock.Value) {
		$counter++
		Write-Host $stock.Key $closingPrice
	}
}

if ($counter -eq 0) {
    Write-Output "No stocks found below the specified price limits."
}