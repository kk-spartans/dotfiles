mise activate pwsh | Out-String | Invoke-Expression

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
Remove-Item Alias:where -ErrorAction SilentlyContinue -Force
Set-Alias where "$env:SystemRoot\System32\where.exe"


Set-Alias pb Get-Clipboard
Set-Alias sc Set-Clipboard

# === Sudo Choco ===
function choco {
    gsudo choco @args
}

function ocrmypdf {
    ocrmypdf.exe  --language eng  --output-type pdf --verbose 1 --rotate-pages --deskew --clean --force-ocr --pdf-renderer sandwich --optimize 1 @args
}

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

# === Copy File Contents ===
function copy {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$File
    )
    Get-Content $File | Set-Clipboard
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
function Find-CodeWorkspaceRoot {
    param(
        [Parameter(Mandatory=$true)]
        [string]$StartPath
    )

    $markers = @(
        "node_modules",
        "pyproject.toml",
        ".git"
    )

    $current = $StartPath

    while ($current) {
        foreach ($marker in $markers) {
            if (Test-Path -LiteralPath (Join-Path -Path $current -ChildPath $marker)) {
                return $current
            }
        }

        $parent = Split-Path -Path $current -Parent
        if (-not $parent -or $parent -eq $current) {
            break
        }

        $current = $parent
    }

    return $null
}

function Find-GitSubcommandIndex {
    param(
        [string[]]$Args
    )

    $optionsWithValues = @(
        '-c',
        '-C',
        '--exec-path',
        '--git-dir',
        '--work-tree',
        '--namespace',
        '--config-env',
        '--super-prefix'
    )

    for ($i = 0; $i -lt $Args.Count; $i++) {
        $arg = $Args[$i]

        if ($arg -eq '--') {
            if ($i + 1 -lt $Args.Count) {
                return $i + 1
            }

            break
        }

        if ($arg.StartsWith('--')) {
            if ($arg.Contains('=')) {
                continue
            }

            if ($optionsWithValues -contains $arg) {
                $i++
            }

            continue
        }

        if ($arg.StartsWith('-') -and $arg -ne '-') {
            if ($optionsWithValues -contains $arg) {
                $i++
            }

            continue
        }

        return $i
    }

    return -1
}

function Get-CloneTargetDirectory {
    param(
        [string[]]$Args,
        [int]$CloneIndex
    )

    $optionsWithValues = @(
        '-b',
        '-c',
        '-o',
        '-u',
        '-j',
        '--branch',
        '--config',
        '--depth',
        '--jobs',
        '--origin',
        '--reference',
        '--reference-if-able',
        '--separate-git-dir',
        '--server-option',
        '--shallow-exclude',
        '--shallow-since',
        '--template',
        '--upload-pack'
    )

    $operands = @()
    $literalMode = $false

    for ($i = $CloneIndex + 1; $i -lt $Args.Count; $i++) {
        $arg = $Args[$i]

        if (-not $literalMode) {
            if ($arg -eq '--') {
                $literalMode = $true
                continue
            }

            if ($arg.StartsWith('--')) {
                if ($arg.Contains('=')) {
                    continue
                }

                if ($optionsWithValues -contains $arg) {
                    $i++
                }

                continue
            }

            if ($arg.StartsWith('-') -and $arg -ne '-') {
                if ($optionsWithValues -contains $arg) {
                    $i++
                }

                continue
            }
        }

        $operands += $arg
    }

    if ($operands.Count -ge 2) {
        return $operands[-1]
    }

    if ($operands.Count -eq 1) {
        $repo = $operands[0].TrimEnd('/', '\')
        $name = Split-Path -Path $repo -Leaf

        if ([string]::IsNullOrWhiteSpace($name) -and $repo -match '[:/]([^:/\\]+?)(?:\.git)?$') {
            $name = $Matches[1]
        }

        if ($name.EndsWith('.git', [System.StringComparison]::OrdinalIgnoreCase)) {
            $name = $name.Substring(0, $name.Length - 4)
        }

        return $name
    }

    return $null
}

function Invoke-CloneAndEnter {
    param(
        [Parameter(Mandatory=$true)]
        [string]$CommandName,
        [string[]]$Args
    )

    $command = Get-Command $CommandName -CommandType Application -ErrorAction SilentlyContinue

    if (-not $command) {
        Write-Error "$CommandName not found in PATH."
        return
    }

    $cloneIndex = Find-GitSubcommandIndex -Args $Args

    if ($cloneIndex -lt 0 -or $Args[$cloneIndex] -ne 'clone') {
        & $command.Source @Args
        return
    }

    $targetDir = Get-CloneTargetDirectory -Args $Args -CloneIndex $cloneIndex

    & $command.Source @Args

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($targetDir)) {
        return
    }

    try {
        $resolvedTarget = Resolve-Path -LiteralPath $targetDir -ErrorAction Stop | Select-Object -First 1 -ExpandProperty Path
        if (Test-Path -LiteralPath $resolvedTarget -PathType Container) {
            Set-Location -LiteralPath $resolvedTarget
        }
    } catch {
    }
}

# === Fix ls command ===
function ls {
    param([string]$Path = '.')
    if ($Path -like '~*') { $Path = $Path -replace '^~', $HOME }
    eza --all --git --icons --group-directories-first $Path
}

function kill {
    fkill --force @args
}

function git {
    Invoke-CloneAndEnter -CommandName 'git.exe' -Args $args
}

function gix {
    Invoke-CloneAndEnter -CommandName 'gix.exe' -Args $args
}

# === Bat to Cat ===
function cat {
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Paths
    )

    process {
        if (-not $_ -and (-not $Paths -or $Paths.Count -eq 0)) {
            return
        }

        $inputs = @()
        if ($_ -ne $null) { $inputs += $_ }
        if ($Paths) { $inputs += $Paths }

        foreach ($p in $inputs) {
            $expanded = @()

            $path = $p -replace '^~', $HOME

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
                    if ($childFiles) { $expanded += $childFiles.FullName }
                } else {
                    $expanded += $item.FullName
                }
            }

            foreach ($target in $expanded) {
                if (Test-Path $target) {
                    if ($target -match '\.(md|markdown)$') {
                        glow $target
                    } else {
                        # if piped, read from stdin if filename is "-"
                        if ($target -eq '-') {
                            bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" -
                        } else {
                            bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" $target
                        }
                    }
                }
            }
        }
    }
}

# === cd command ===
function cd {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        Set-Location ..
        return
    }

    z $Path
}

# === Explorer Shortcut ===
function exp {
    explorer .
}

# === bun x wrappers ===
function npx {
    bun x @args
}

function bunx {
    bun x @args
}

function bdcli {
    if ($args.Count -gt 0) {
        bdcli.exe @args
        return
    }

    bdcli.exe --help
}

# === Smart VS Code Launch ===
function code {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$UserArgs
    )

    $codeCmd = Get-Command code.cmd -CommandType Application -ErrorAction SilentlyContinue
    $currentDir = [System.IO.Path]::GetFullPath((Get-Location).Path)

    if (-not $codeCmd) {
        Write-Error "VS Code command not found in PATH."
        return
    }

    if (-not $UserArgs -or $UserArgs.Count -eq 0) {
        & $codeCmd.Source .
        return
    }

    $workspaceRoot = $null

    foreach ($arg in $UserArgs) {
        if ($arg.StartsWith('-')) {
            continue
        }

        try {
            $resolved = Resolve-Path -LiteralPath $arg -ErrorAction Stop | Select-Object -First 1 -ExpandProperty Path
        } catch {
            continue
        }

        $resolvedFullPath = [System.IO.Path]::GetFullPath($resolved)
        $currentDirPrefix = $currentDir.TrimEnd('\') + '\'

        if ($resolvedFullPath -ne $currentDir -and -not $resolvedFullPath.StartsWith($currentDirPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        if (Test-Path -LiteralPath $resolved -PathType Container) {
            $startPath = $resolved
        } else {
            $startPath = Split-Path -Path $resolved -Parent
        }

        $workspaceRoot = Find-CodeWorkspaceRoot -StartPath $startPath
        if ($workspaceRoot) {
            break
        }
    }

    if ($workspaceRoot) {
        & $codeCmd.Source $workspaceRoot @UserArgs
        return
    }

    & $codeCmd.Source @UserArgs
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
    git commit -S -m "$m"
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git pull --rebase
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git push
    git status
}

function cpf {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Paths
    )

    if (-not $Paths) {
        Write-Error "Give me something to copy."
        return
    }

    # Normalize paths (relative or absolute)
    $files = foreach ($p in $Paths) {
        try {
            Resolve-Path $p -ErrorAction Stop | Select-Object -ExpandProperty Path
        } catch {
            Write-Error "Can't find '$p'"
        }
    }

    if (-not $files) {
        Write-Error "Nothing valid to put on clipboard."
        return
    }

    Add-Type -AssemblyName System.Windows.Forms | Out-Null
    $dataObject = New-Object System.Windows.Forms.DataObject
    $dataObject.SetFileDropList($files)
    [System.Windows.Forms.Clipboard]::SetDataObject($dataObject, $true)
}

Remove-Item Alias:mv -ErrorAction SilentlyContinue
Remove-Item Alias:cp -ErrorAction SilentlyContinue

function mv {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    if ($Args.Count -lt 2) {
        throw "mv needs at least a source and a destination"
    }

    $dest = $Args[-1]
    $sources = $Args[0..($Args.Count - 2)]

    foreach ($src in $sources) {
        Move-Item -Path $src -Destination $dest
    }
}

function cp {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    if ($Args.Count -lt 2) {
        throw "cp needs at least a source and a destination"
    }

    $dest = $Args[-1]
    $sources = $Args[0..($Args.Count - 2)]

    foreach ($src in $sources) {
        Copy-Item -Path $src -Destination $dest -Recurse
    }
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
Set-Alias wignet winget
function oc {
    $cliArgs = @()
    $offset = 0

    if ($args.Count -gt 0 -and -not $args[0].StartsWith('-')) {
        $cliArgs += '--prompt'
        $cliArgs += $args[0]
        $offset = 1
    }

    if ($args.Count -gt $offset -and -not $args[$offset].StartsWith('-')) {
        $cliArgs += '--model'
        $cliArgs += $args[$offset]
        $offset += 1
    }

    for ($i = $offset; $i -lt $args.Count; $i++) {
        $cliArgs += $args[$i]
    }

    opencode @cliArgs
}
Remove-Item alias:copy
