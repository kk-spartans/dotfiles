param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$UserArgs
)

function Find-CodeWorkspaceRoot {
    param(
        [Parameter(Mandatory=$true)]
        [string]$StartPath
    )

    $markers = @(
        'node_modules',
        'pyproject.toml',
        '.git'
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

$codeCmd = Get-Command code.cmd -CommandType Application -ErrorAction SilentlyContinue
$currentDir = [System.IO.Path]::GetFullPath((Get-Location).Path)

if (-not $codeCmd) {
    Write-Error 'VS Code command not found in PATH.'
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
