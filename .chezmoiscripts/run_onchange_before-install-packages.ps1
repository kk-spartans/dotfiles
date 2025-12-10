winget import -i "$env:userprofile/.local/share/chezmoi/.hidden/import.json" --accept-package-agreements --accept-source-agreements
winget upgrade --all --force --include-unknown --accept-package-agreements --accept-source-agreements
