# Jared Marcuccilli

$file = Get-Item -Path random-text.txt

Write-Output "File details:"
Write-Output (Get-Item -Path random-text.txt)

Write-Output "`nHere are the first seven lines from the file.`n"

Get-Content $file -Head 7

Write-Output "`nHere are the last five lines from the file.`n"

Get-Content $file -Tail 5

Write-Output "`nHere are the eleventh to the thirteenth lines.`n"

Get-Content $file | Select-Object -Index (10..12)

Write-Output "`nAnd here are some details about the content in the file.`n"
 
Write-Output (Get-Content $file | Measure-Object -Line -Word -Character)

Write-Output "`nFinally, the content will be imported into a variable. Let us see if the content is a singe line of text or not."

$content = Get-Content $file

$elements = $content.Count

Write-Output "There are $elements elements in the variable."

$contentRaw = Get-Content $file -Raw

$elementsRaw = $contentRaw.Count

Write-Output "When read as raw content, the number of elements is $elementsRaw"