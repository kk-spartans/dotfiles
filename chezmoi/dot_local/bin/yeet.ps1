param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

foreach ($path in $Paths) {
    try {
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
    } catch {
    }
}

