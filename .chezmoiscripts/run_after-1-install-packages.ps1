winget import -i "$env:userprofile/.local/share/chezmoi/.hidden/import.json" --accept-package-agreements --accept-source-agreements --silent | Out-Null
winget upgrade --all --force --accept-package-agreements --accept-source-agreements --silent | Out-Null

mise install
mise upgrade --bump
