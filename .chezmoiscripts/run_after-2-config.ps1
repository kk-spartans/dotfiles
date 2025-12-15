bat cache --build
komorebic enable-autostart --whkd

$gitPath = "$env:localappdata\Programs\Git\usr\bin"
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$gitPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$gitPath", "User")
}

[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")

$wsh = New-Object -ComObject WScript.Shell
$shortcut = $wsh.CreateShortcut("$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\yasb.lnk")
$shortcut.TargetPath = "C:\Program Files\YASB\yasb.exe"
$shortcut.Save()