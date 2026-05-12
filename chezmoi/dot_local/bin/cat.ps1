param(
    [Parameter(ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

process {
    if (-not $_ -and (-not $Paths -or $Paths.Count -eq 0)) {
        return
    }

    $inputs = @()
    if ($_ -ne $null) {
        $inputs += $_
    }
    if ($Paths) {
        $inputs += $Paths
    }

    foreach ($inputPath in $inputs) {
        $expanded = @()
        $path = $inputPath -replace '^~', $HOME
        $isWildcard = $path -match '[\*\?\[]'

        if ($isWildcard) {
            $items = Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue
            if (-not $items) {
                $expanded += $path
                continue
            }
        } elseif (Test-Path -LiteralPath $path) {
            $items = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
        } else {
            $expanded += $path
            continue
        }

        foreach ($item in $items) {
            if ($item.PSIsContainer) {
                $childFiles = Get-ChildItem -LiteralPath $item.FullName -File -Force -ErrorAction SilentlyContinue
                if ($childFiles) {
                    $expanded += $childFiles.FullName
                }
            } else {
                $expanded += $item.FullName
            }
        }

        foreach ($target in $expanded) {
            if (-not (Test-Path -LiteralPath $target)) {
                continue
            }

            if ($target -match '\.(md|markdown)$') {
                glow $target
                continue
            }

            if ($target -eq '-') {
                bat -
            } else {
                bat $target
            }
        }
    }
}
