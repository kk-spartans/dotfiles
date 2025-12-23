winget import -i "$env:userprofile/.local/share/chezmoi/.hidden/import.json" --accept-package-agreements --accept-source-agreements

winget pin add --id Microsoft.VisualStudio.Community --blocking
winget pin add --id Spotify.Spotify --blocking
winget pin add --id Buanzo.FFmpegforAudacity --blocking

winget upgrade --all --accept-package-agreements --accept-source-agreements

mise install
mise upgrade --bump
