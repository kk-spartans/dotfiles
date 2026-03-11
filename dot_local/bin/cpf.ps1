param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

if (-not $Paths) {
    Write-Error 'Give me something to copy.'
    return
}

$files = foreach ($path in $Paths) {
    try {
        Resolve-Path -LiteralPath $path -ErrorAction Stop | Select-Object -ExpandProperty Path
    } catch {
        Write-Error "Can't find '$path'"
    }
}

if (-not $files) {
    Write-Error 'Nothing valid to put on clipboard.'
    return
}

Add-Type -AssemblyName System.Windows.Forms | Out-Null
$dataObject = New-Object System.Windows.Forms.DataObject
$dataObject.SetFileDropList($files)
[System.Windows.Forms.Clipboard]::SetDataObject($dataObject, $true)
