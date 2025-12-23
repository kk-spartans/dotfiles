bat cache --build
komorebic enable-autostart --whkd
yasbc enable-autostart

$gitPath = "$env:localappdata\Programs\Git\usr\bin"
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$gitPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$gitPath", "User")
}

[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")