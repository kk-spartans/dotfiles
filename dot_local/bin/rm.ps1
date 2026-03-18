param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

foreach ($path in $Paths) {
    try {
        gomi "$path"
    } catch {
    }
}
