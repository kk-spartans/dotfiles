$nonInteractiveArgs = @('-NonInteractive','-Command','-c','-EncodedCommand','-e','-File','-f')
if (-not [Environment]::UserInteractive -or
    ([Environment]::GetCommandLineArgs() | Where-Object { $_ -in $nonInteractiveArgs })) {
    return
}

# ==============================================================================
# === Aliases ===
# ==============================================================================
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

# ==============================================================================
# === File Operations ===
# ==============================================================================
# === Get Touch ===
function touch {
    foreach ($arg in $args) {
        if (!(Test-Path $arg)) {
            New-Item -ItemType File -Path $arg | Out-Null
        }
        else {
            (Get-Item $arg).LastWriteTime = Get-Date
        }
    }
}

# === Proper rm ===
function rm {
    foreach ($path in $args) {
        try {
            Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
        } catch {
            # silence
        }
    }
}

# === Make A File Hidden ===
function mkh {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Paths
    )
    foreach ($path in $Paths) {
        if (Test-Path $path) {
            (Get-Item $path).Attributes += 'Hidden'
        } else {
            Write-Warning "Path not found: $path"
        }
    }
}

# === Make A File Not Hidden ===
function mknh {
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
}

# ==============================================================================
# === Shell Commands ===
# ==============================================================================
# === Fix ls command ===
function ls {
    param([string]$Path = '.')
    if ($Path -like '~*') { $Path = $Path -replace '^~', $HOME }
    eza --all --git --icons --group-directories-first $Path
}

# === Bat to Cat ===
function cat {
    param([string]$Path)
    if ($Path -like '~*') { $Path = $Path -replace '^~', $HOME }
    bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" $Path
}

# === cd command ===
function cd {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = '~'
    )
    z $Path
}

# ==============================================================================
# === Git Tools ===
# ==============================================================================
# === Git Shortcut ===
function gs {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$m
    )
    git add --all
    git commit -m "$m"
    git push
    git pull
    git status
}

# ==============================================================================
# === Initialization ===
# ==============================================================================
# === Initialize oh-my-posh ===
Invoke-Expression (& { oh-my-posh init pwsh --config "$env:userprofile/catppuccin.omp.json" })

# === Initialize zoxide ===
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# === PSReadLine Configuration ===
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi
