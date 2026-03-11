param(
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

foreach ($path in $Paths) {
    if (Test-Path -LiteralPath $path) {
        (Get-Item -LiteralPath $path).Attributes += 'Hidden'
    } else {
        Write-Warning "Path not found: $path"
    }
}
