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
