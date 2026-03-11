param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$File
)

Get-Content -LiteralPath $File | Set-Clipboard
