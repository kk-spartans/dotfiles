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
Remove-Item Alias:rm
function rm {
    foreach ($path in $args) {
        try {
            Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
        } catch {
            # silence
        }
    }
}

# === Fix ls command ===
Remove-Item Alias:ls
function ls {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = '.'
    )

    eza --all --git --icons --group-directories-first $Path
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

#===Bat to Cat
Remove-Item Alias:cat
function cat {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" $Path
}

#===cd command===
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Item Alias:cd
function cd {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = '~'
    )
    z $Path
}

#===yazi===
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}


Invoke-Expression (& { oh-my-posh init pwsh --config "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\catppuccin_mocha.omp.json" })

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi
# Set-PSReadLineKeyHandler -Key DownArrow -Function MenuComplete
Set-Alias pb Get-Clipboard
