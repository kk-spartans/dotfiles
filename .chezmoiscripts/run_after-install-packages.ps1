winget import -i "$env:userprofile/.local/share/chezmoi/.hidden/import.json" --accept-package-agreements --accept-source-agreements
winget upgrade --all --force --accept-package-agreements --accept-source-agreements

mise install
mise upgrade --bump
