# === Initialize oh-my-posh ===
Invoke-Expression (& { oh-my-posh init pwsh --config "$env:userprofile/catppuccin.omp.json" })

# === Initialize zoxide ===
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# === PSReadLine Configuration ===
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi
