param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

foreach ($path in $Paths) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType File -Path $path | Out-Null
        continue
    }

    (Get-Item -LiteralPath $path).LastWriteTime = Get-Date
}
