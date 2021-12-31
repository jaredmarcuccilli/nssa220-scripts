# Jared Marcuccilli

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [String]$DaysOfLogging,

  [Parameter(Mandatory=$true)]
  [String]$OutputFile,

  [Parameter(Mandatory=$true)]
  [String]$EntryType
)

$Events = Get-EventLog -LogName Application -After (Get-Date).AddDays(-$DaysOfLogging) -EntryType $EntryType -ErrorAction SilentlyContinue

Write-Output "Entries: "
$Events.Count

'"MachineName","EventID","EntryType","Message","Source"' | Out-File -FilePath $OutputFile

if ($Events.Count -eq 0) {
    "Hmm, looks like there weren't any entries matching that criteria."
    $LookFor = Read-Host -Prompt "-> Enter an Event ID to look for, otherwise type 'exit' to cancel"
    if ($LookFor -eq "exit") {
        exit
    }
    $Events = Get-EventLog -LogName Application -After (Get-Date).AddDays(-$DaysOfLogging) -ErrorAction SilentlyContinue
    Write-Output "Entries: "
    $Events.Count
    foreach ($Event in $Events) {
        if($Event.EventID -eq $LookFor) {
            $eventString = '"'
            $eventString += $Event.MachineName
            $eventString += '","'
            $eventString += $Event.EventID
            $eventString += '","'
            $eventString += $Event.EntryType
            $eventString += '","'
            $eventString += $Event.Message
            $eventString += '","'
            $eventString += $Event.Source
            $eventString += '"'
            $eventString | Out-File -Append $OutputFile
        }
    }
} else {
    foreach ($Event in $Events) {
        $eventString = '"'
        $eventString += $Event.MachineName
        $eventString += '","'
        $eventString += $Event.EventID
        $eventString += '","'
        $eventString += $Event.EntryType
        $eventString += '","'
        $eventString += $Event.Message
        $eventString += '","'
        $eventString += $Event.Source
        $eventString += '"'
        $eventString | Out-File -Append $OutputFile
    }
}

# The instructions say to remove the file when done, but then you won't be able to read it, so I'll leave this commented.
# Remove-Item $OutputFile