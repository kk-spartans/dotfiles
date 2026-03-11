param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Pfile:///C:/Users/kk-spartans/Downloads/CS.pdfaths
)

foreach ($path in $Paths) {
    try {
        trash $path --verbose *>$null
    } catch {
    }
}
