 $gitPath1 = "$env:localappdata\Programs\Git\usr\bin"
 $gitPath2 = "C:\Program Files\Git\usr\bin"
 $misePath = "$env:localappdata\mise\shims"
 $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
 if (Test-Path $gitPath1) {
     $gitPath = $gitPath1
 } elseif (Test-Path $gitPath2) {
     $gitPath = $gitPath2
 }
 if ($gitPath -and ($userPath -notlike "*$gitPath*")) {
     $userPath += ";$gitPath"
     [Environment]::SetEnvironmentVariable("PATH", $userPath, "User")
 }
 if ($userPath -notlike "*$misePath*") {
     $userPath += ";$misePath"
     [Environment]::SetEnvironmentVariable("PATH", $userPath, "User")
 }

 $Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

 [Environment]::SetEnvironmentVariable("EDITOR", "code", "User")

 bat cache --build
 komorebic enable-autostart --whkd
 yasbc enable-autostart
