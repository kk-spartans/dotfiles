if (-not [Environment]::UserInteractive -or $PSCmdlet.ParameterSetName -eq 'NonInteractive' -or [Environment]::GetCommandLineArgs() -match '-NonInteractive|-Command|-c|-File|-f') {
    return
}

# === Import PowerShell Tools and Modules ===
$toolsPath = Join-Path $PROFILE -ChildPath '..\Modules\tools'

. (Join-Path $toolsPath 'Aliases.ps1')

. (Join-Path $toolsPath 'FileOperations.ps1')
. (Join-Path $toolsPath 'ShellCommands.ps1')
. (Join-Path $toolsPath 'GitTools.ps1')
. (Join-Path $toolsPath 'Initialization.ps1')
