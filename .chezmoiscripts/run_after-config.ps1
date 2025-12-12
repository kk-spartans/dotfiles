bat cache --build

function Add-EnvPath {
    param(
        [string]$Path,
        [ValidateSet('User', 'Machine')][string]$Scope = 'User',
        [ValidateSet('PATH', 'PYTHONPATH', 'NODE_PATH')][string]$VariableName = 'PATH'
    )
    
    $currentValue = [Environment]::GetEnvironmentVariable($VariableName, $Scope)
    $paths = $currentValue -split [System.IO.Path]::PathSeparator | Where-Object { $_ }
    
    if ($Path -notin $paths) {
        $newValue = "$Path$([System.IO.Path]::PathSeparator)$currentValue"
        [Environment]::SetEnvironmentVariable($VariableName, $newValue, $Scope)
        ${env:$VariableName} = $newValue
        return $true
    }
    return $false
}

Add-EnvPath -Path "$env:userprofile\AppData\Local\mise\shims" -Scope User -VariableName PATH
Add-EnvPath -Path "$env:localappdata\Programs\Git\usr\bin" -Scope User -VariableName PATH

$yasbShortcutPath = Join-Path ([Environment]::GetFolderPath('Startup')) 'YASB.lnk'
if (-not (Test-Path $yasbShortcutPath)) {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($yasbShortcutPath)
    $shortcut.TargetPath = 'C:\Program Files\YASB\yasb.exe'
    $shortcut.WorkingDirectory = 'C:\Program Files\YASB'
    $shortcut.Save()
}

komorebic enable-autostart --whkd
