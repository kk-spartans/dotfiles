param(
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

foreach ($path in $Paths) {
    try {
        $item = Get-Item -LiteralPath $path -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::Hidden) {
            $item.Attributes = $item.Attributes -bxor [System.IO.FileAttributes]::Hidden
        }
    } catch {
        Write-Warning "Can't access: $path"
    }
}
