
$Years = 1992..$((Get-Date).Year)
$AllResults = @()
$DrawDates = @()
$regex = '^(?:(((Jan(uary)?|Ma(r(ch)?|y)|Jul(y)?|Aug(ust)?|Oct(ober)?|Dec(ember)?)\ 31)|((Jan(uary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sept|Nov|Dec)(ember)?)\ (0?[1-9]|([12]\d)|30))|(Feb(ruary)?\ (0?[1-9]|1\d|2[0-8]|(29(?=,\ ((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))))))\,\ ((1[6-9]|[2-9]\d)\d{2}))'

foreach ($Year in $Years) {
    $DrawDate = 0
    $Uri = "https://www.lottery.net/powerball/numbers/$Year"
    $Request = Invoke-WebRequest -Uri $Uri
    $WinningNumbers = @($Request.ParsedHtml.body.getElementsByClassName('powerball') | Select-Object -ExpandProperty InnerText)
    $DrawDates = @($Request.Links | Select-Object -ExpandProperty innerhtml) -split '<BR>' -match $regex
    
    for ($i = 0; $i -lt $WinningNumbers.Length; $i += 2) {
        $Numbers = ($WinningNumbers[$i] -split '\r?\n').Trim()
        $AllResults  += [pscustomobject][ordered]@{
            Ball1     = $Numbers[0]
            Ball2     = $Numbers[1]
            Ball3     = $Numbers[2]
            Ball4     = $Numbers[3]
            Ball5     = $Numbers[4]
            PowerBall = $Numbers[5]
            PowerPlay = $Numbers[6]
            DrawDate  = $DrawDates[$DrawDate]
        }
        $DrawDate++
    }
}

$AllResults
