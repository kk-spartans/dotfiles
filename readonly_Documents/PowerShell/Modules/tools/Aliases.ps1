# === Remove default aliases and set custom ones ===
Remove-Item Alias:rm -ErrorAction SilentlyContinue
Remove-Item Alias:ls -ErrorAction SilentlyContinue
Remove-Item Alias:cat -ErrorAction SilentlyContinue
Remove-Item Alias:cd -ErrorAction SilentlyContinue
Remove-Item Alias:gc -ErrorAction SilentlyContinue
Remove-Item Alias:sc -ErrorAction SilentlyContinue

Set-Alias pb Get-Clipboard
Set-Alias sc Set-Clipboard

# Custom kill function that accepts process names
function Kill-Process {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )
    Stop-Process -Name $ProcessName -ErrorAction SilentlyContinue
}

Set-Alias kill Kill-Process
