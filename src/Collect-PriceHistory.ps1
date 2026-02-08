<#
Author: Negar Kohansal
Purpose: Collect price data from REST API and build historical price table in SQL Server
Schedule: SQL Server Agent
#>

# TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$api = "PRICE_API_URL"
$headers = @{
    Authorization = "PRICE_API_TOKEN"
    Accept        = "application/json"
    "User-Agent"  = "PowerShellScript/1.0"
}

$connString = "Server=YourServerName;Database=YourDatabaseName;Trusted_Connection=True"

try {
# Call REST API
    $response = Invoke-RestMethod -Uri $api -Headers $headers -Method Get
    $rows = $response.result.data

    if (-not $rows -or $rows.Count -eq 0) {
        Write-Host "No data returned from API"
        exit
    }

# Normalize Persian fields
    $cleanRows = $rows | Select-Object `
        key, category,
        @{n="Title";e={$_.عنوان}},
        @{n="Price";e={[int64]$_.قیمت}},
        @{n="ChangeValue";e={[decimal]$_.تغییر}},
        @{n="HighPrice";e={[int64]$_.بیشترین}},
        @{n="LowPrice";e={[int64]$_.کمترین}},
        updated_at

    $conn = New-Object System.Data.SqlClient.SqlConnection($connString)
    $conn.Open()

# Insert into SQL Server with duplicate protection

    foreach ($r in $cleanRows) {

        if (-not $r.updated_at) { continue }

        $cmd = $conn.CreateCommand()
$cmd.CommandText = @"
IF NOT EXISTS (
    SELECT 1 FROM MarketData.PriceHistory
    WHERE ItemKey=@k AND UpdateDateTime=@d
)
INSERT INTO MarketData.PriceHistory
(ItemKey,Category,Title,Price,ChangeValue,HighPrice,LowPrice,UpdateDateTime,InsertDateTime)
VALUES
(@k,@c,@t,@p,@chg,@h,@l,@d,SYSUTCDATETIME())
"@

        $cmd.Parameters.AddWithValue("@k",$r.key)       | Out-Null
        $cmd.Parameters.AddWithValue("@c",$r.category)  | Out-Null
        $cmd.Parameters.AddWithValue("@t",$r.Title)     | Out-Null
        $cmd.Parameters.AddWithValue("@p",$r.Price)     | Out-Null
        $cmd.Parameters.AddWithValue("@chg",$r.ChangeValue) | Out-Null
        $cmd.Parameters.AddWithValue("@h",$r.HighPrice) | Out-Null
        $cmd.Parameters.AddWithValue("@l",$r.LowPrice)  | Out-Null
        $cmd.Parameters.AddWithValue("@d",[datetime]$r.updated_at) | Out-Null

        $cmd.ExecuteNonQuery() | Out-Null
        Write-Host "Inserted -> $($r.key)"
    }

    $conn.Close()
    Write-Host "DONE"

} catch {
    Write-Host "ERROR:"
    Write-Host $_
} 