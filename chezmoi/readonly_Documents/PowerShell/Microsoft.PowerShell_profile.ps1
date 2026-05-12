$isInteractiveShell = $Host.Name -eq 'ConsoleHost' -and -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected -and ([Environment]::CommandLine -notmatch '-NonInteractive')

if ($isInteractiveShell -and (Get-Command mise -ErrorAction SilentlyContinue)) {
    mise activate pwsh | Out-String | Invoke-Expression
}

Remove-Item Alias:rm -ErrorAction SilentlyContinue
Remove-Item Alias:ls -ErrorAction SilentlyContinue
Remove-Item Alias:cat -ErrorAction SilentlyContinue
Remove-Item Alias:cd -ErrorAction SilentlyContinue
Remove-Item Alias:gc -ErrorAction SilentlyContinue
Remove-Item Alias:sc -ErrorAction SilentlyContinue
Remove-Item Alias:copy -ErrorAction SilentlyContinue
Remove-Item Alias:mv -ErrorAction SilentlyContinue
Remove-Item Alias:cp -ErrorAction SilentlyContinue
Remove-Item Alias:where -ErrorAction SilentlyContinue -Force

Set-Alias where "$env:SystemRoot\System32\where.exe"
Set-Alias pb Get-Clipboard
Set-Alias sc Set-Clipboard
Set-Alias npx bunx
Set-Alias ocrmypdf "$env:USERPROFILE\.local\bin\ocrmypdf.ps1"
Set-Alias bash C:\msys64\usr\bin\bash.exe
Set-Alias ab agent-browser

function cd {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        Set-Location -
        return
    }

    z $Path
}

if ($isInteractiveShell) {
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        oh-my-posh init pwsh --config "$env:userprofile/catppuccin.omp.json" | Out-String | Invoke-Expression
    }

    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        zoxide init powershell | Out-String | Invoke-Expression
    }

    if (Get-Command thefuck -ErrorAction SilentlyContinue) {
        thefuck --alias | Out-String | Invoke-Expression
    }

    if (Get-Module -ListAvailable -Name PSReadLine) {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue
        Set-PSReadLineOption -EditMode Vi -ErrorAction SilentlyContinue
    }
}
