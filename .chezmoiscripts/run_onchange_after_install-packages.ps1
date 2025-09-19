$packages = @(
    "7zip.7zip",
    "Audacity.Audacity",
    "Docker.DockerDesktop",
    "Buanzo.FFmpegforAudacity",
    "REALiX.HWiNFO",
    "Zen-Team.Zen-Browser",
    "GitHub.cli",
    "LGUG2Z.komorebi",
    "ShiningLight.OpenSSL.Dev",
    "AmN.yasb",
    "JanDeDobbeleer.OhMyPosh",
    "JohnMacFarlane.Pandoc",
    "Google.GoogleDrive",
    "Volta.Volta",
    "voidtools.Everything",
    "LGUG2Z.whkd",
    "BlenderFoundation.Blender",
    "OBSProject.OBSStudio",
    "Parsec.Parsec",
    "Microsoft.VisualStudio.2022.Community",
    "Microsoft.PowerShell",
    "BurntSushi.ripgrep.GNU",
    "Flow-Launcher.Flow-Launcher",
    "GIMP.GIMP.2",
    "Git.Git",
    "Google.PlatformTools",
    "Gyan.FFmpeg",
    "MiKTeX.MiKTeX",
    "Spotify.Spotify",
    "Spicetify.Spicetify",
    "ajeetdsouza.zoxide",
    "astral-sh.uv",
    "Obsidian.Obsidian",
    "eza-community.eza",
    "junegunn.fzf",
    "Ollama.Ollama",
    "Microsoft.VisualStudioCode",
    "Microsoft.PowerToys",
    "Microsoft.WindowsTerminal",
    "sharkdp.bat",
    "Anthropic.Claude",
    "sxyazi.yazi",
    "jqlang.jq",
    "oschwartz10612.Poppler",
    "sharkdp.fd",
    "ImageMagick.ImageMagick",
    "Rustlang.Rustup",
    "GoLang.Go",
    "twpayne.chezmoi"
)

foreach ($packageId in $packages) {
    winget install --id="$packageId" --source="winget" --accept-package-agreements --accept-source-agreements --force
}

Invoke-WebRequest -useb https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.ps1 | Invoke-Expression

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

volta install nodejs
volta install pnpm

uv tool install yt-dlp
uv tool install spotdl
uv tool install ocrmypdf
uv tool install copyparty
uv tool install mcpo
uv tool install tldr

go install github.com/samyakbardiya/trex@latest

Get-ChildItem ~\things\docker\docker-compose | ForEach-Object { Push-Location $_.FullName; docker compose up -d --force-recreate; Pop-Location }

[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", (Resolve-Path "$HOME\AppData\Local\Programs\Git\usr\bin\file.exe").Path, "User")
