winget install --id="7zip.7zip" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Audacity.Audacity" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Docker.DockerDesktop" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Buanzo.FFmpegforAudacity" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="REALiX.HWiNFO" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Zen-Team.Zen-Browser" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="GitHub.cli" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="LGUG2Z.komorebi" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="ShiningLight.OpenSSL.Dev" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="AmN.yasb" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="JanDeDobbeleer.OhMyPosh" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="JohnMacFarlane.Pandoc" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Google.GoogleDrive" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Volta.Volta" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="voidtools.Everything" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="LGUG2Z.whkd" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="BlenderFoundation.Blender" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="OBSProject.OBSStudio" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Parsec.Parsec" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Microsoft.VisualStudio.2022.Community" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Microsoft.PowerShell" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="BurntSushi.ripgrep.GNU" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Flow-Launcher.Flow-Launcher" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="GIMP.GIMP.2" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Git.Git" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Google.PlatformTools" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Gyan.FFmpeg" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="MiKTeX.MiKTeX" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Spotify.Spotify" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Spicetify.Spicetify" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="ajeetdsouza.zoxide" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="astral-sh.uv" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Obsidian.Obsidian" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="eza-community.eza" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="junegunn.fzf" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Ollama.Ollama" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Microsoft.VisualStudioCode" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Microsoft.PowerToys" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Microsoft.WindowsTerminal" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="sharkdp.bat" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Anthropic.Claude" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="sxyazi.yazi" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="jqlang.jq" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="oschwartz10612.Poppler" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="sharkdp.fd" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="ImageMagick.ImageMagick" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Rustlang.Rustup" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="GoLang.Go" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="twpayne.chezmoi" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Ookla.Speedtest.CLI" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Gitleaks.Gitleaks" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="dandavison.delta" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="Tailscale.Tailscale" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="gerardog.gsudo" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="max-niederman.ttyper" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="JesseDuffield.Lazydocker" --source="winget" --accept-package-agreements --accept-source-agreements
winget install --id="JesseDuffield.lazygit" --source="winget" --accept-package-agreements --accept-source-agreements

Invoke-WebRequest -useb https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.ps1 | Invoke-Expression

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

volta install "nodejs"
volta install "pnpm"

uv tool install "yt-dlp"
uv tool install "spotdl"
uv tool install "ocrmypdf"
uv tool install "copyparty"
uv tool install "mcpo"
uv tool install "tldr"

go install "github.com/samyakbardiya/trex@latest"
go install "github.com/jesseduffield/lazynpm@latest"

cargo install --locked lazycli

code --install-extension="brian-njogu.gitlantis"
code --install-extension="esbenp.prettier-vscode"
code --install-extension="github.copilot"
code --install-extension="github.copilot-chat"
code --install-extension="catppuccin.catppuccin-vsc"
code --install-extension="mhutchie.git-graph"
code --install-extension="miguelsolorio.symbols"
code --install-extension="mkxml.vscode-filesize"
code --install-extension="ms-python.debugpy"
code --install-extension="ms-python.python"
code --install-extension="ms-python.vscode-pylance"
code --install-extension="ms-vscode.powershell"
code --install-extension="usernamehw.errorlens"
code --install-extension="vscodevim.vim"

Start-Job { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"}
Start-Sleep -Seconds "60"
Get-ChildItem "~\things\docker\docker-compose" | ForEach-Object { Push-Location $_.FullName; docker compose up -d --force-recreate; Pop-Location }

[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", (Resolve-Path "$HOME\AppData\Local\Programs\Git\usr\bin\file.exe").Path, "User")
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", (Resolve-Path "$HOME\.config").Path, "User")
