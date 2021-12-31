# Jared Marcuccilli

$file = Get-Item -Path sitelist.csv
$content = Get-Content $file

foreach ($line in $content) {
    if ($line -match "BBC") {
        $linesplit = $line -split ","
        $content = Invoke-WebRequest $linesplit[1]
        $content.links | Where-Object {
            $_.href -like "*travel/*"
        } | Select-Object href
    }
}

Remove-Item sitelist.csv