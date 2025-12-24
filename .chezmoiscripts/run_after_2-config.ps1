function AddToPath {
      param([string]$pathToAdd)
      if (Test-Path $pathToAdd) {
          $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
          if ($userPath -notlike "*$pathToAdd*") {
              $userPath += ";$pathToAdd"
              [Environment]::SetEnvironmentVariable("PATH", $userPath, "User")
          }
      }
}

AddToPath "$env:localappdata\mise\shims"
AddToPath "C:\msys64\ucrt64\bin"
AddToPath "C:\msys64\usr\bin"

[Environment]::SetEnvironmentVariable("EDITOR", "code", "User")

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

bat cache --build
komorebic enable-autostart --whkd
yasbc enable-autostart
