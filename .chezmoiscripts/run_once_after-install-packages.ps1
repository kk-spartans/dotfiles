Write-Host "Installing ripgrep"
winget install --id="BurntSushi.ripgrep.GNU" --source="winget" --accept-package-agreements --accept-source-agreements --disable-interactivity --exact

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# -----------------
# Winget
# -----------------
$wingetApps = @(
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
    "Flow-Launcher.Flow-Launcher",
    "GIMP.GIMP.2",
    "Git.Git",
    "Google.PlatformTools",
    "Gyan.FFmpeg",
    "MiKTeX.MiKTeX",
    "Spotify.Spotify",
    "ajeetdsouza.zoxide",
    "astral-sh.uv",
    "Obsidian.Obsidian",
    "eza-community.eza",
    "junegunn.fzf",
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
    "twpayne.chezmoi",
    "Gitleaks.Gitleaks",
    "dandavison.delta",
    "Tailscale.Tailscale",
    "gerardog.gsudo",
    "JesseDuffield.Lazydocker",
    "JesseDuffield.lazygit",
    "Zoom.Zoom",
    "Ookla.Speedtest.CLI",
    "sharkdp.hyperfine",
    "dandavison.delta"
)

$installedWinget = winget list

foreach ($app in $wingetApps) {
    $installedWinget | rg -iq $app
    $found = $LASTEXITCODE -eq 0

    if (-not $found) {
        Write-Host "Installing $app"
        winget install --id="$app" --exact --accept-package-agreements --accept-source-agreements --disable-interactivity
    } else {
        Write-Host "Skipping $app"
    }
}

# -----------------
# Spicetify
# -----------------
if (-not (Get-Command spicetify -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Spicetify"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/spicetify/cli/main/install.ps1" -UseBasicParsing | Invoke-Expression
} else {
    Write-Host "Skipping Spicetify"
}

# -----------------
# Volta
# -----------------
$installedVolta = volta list
$voltaApps = @(
    "node",
    "pnpm"
)

foreach ($tool in $voltaApps) {
    $installedVolta | rg -iq $tool
    $found = $LASTEXITCODE -eq 0

    if (-not $found) {
        Write-Host "Installing $tool"
        volta install $tool
    } else {
        Write-Host "Skipping $tool"
    }
}

# -----------------
# Pnpm
# -----------------
$installedPnpm = pnpm list -g --depth=0
$pnpmApps = @(
    "tree-sitter-cli"
)

foreach ($pkg in $pnpmApps) {
    $installedPnpm | rg -iq $pkg
    $found = $LASTEXITCODE -eq 0

    if (-not $found) {
        Write-Host "Installing $pkg"
        pnpm install --global $pkg
    } else {
        Write-Host "Skipping $pkg"
    }
}

# -----------------
# Uv
# -----------------
$installedUv = uv tool list
$uvApps = @(
    "yt-dlp",
    "spotdl",
    "ocrmypdf",
    "copyparty",
    "mcpo",
    "tldr",
    "xonsh"
    "oterm"
)

foreach ($uvTool in $uvApps) {
    $installedUv | rg -iq $uvTool
    $found = $LASTEXITCODE -eq 0

    if (-not $found) {
        Write-Host "Installing $uvTool"
        uv tool install $uvTool
    } else {
        Write-Host "Skipping $uvTool"
    }
}

# -----------------
# Go
# -----------------
Write-Host "Installing trex"
go install "github.com/samyakbardiya/trex@latest"
Write-Host "Installing ascii-image-convertor"
go install "github.com/TheZoraiz/ascii-image-converter@latest"


# -----------------
# Nvim
# -----------------
Write-Host "Installing bob"
cargo install "bob-nvim"

bob use latest

# -----------------
# VSCode
# -----------------
$installedExtensions = code --list-extensions
$extensions = @(
    "brian-njogu.gitlantis",
    "esbenp.prettier-vscode",
    "github.copilot",
    "github.copilot-chat",
    "catppuccin.catppuccin-vsc",
    "mhutchie.git-graph",
    "miguelsolorio.symbols",
    "mkxml.vscode-filesize",
    "ms-python.debugpy",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-vscode.powershell",
    "usernamehw.errorlens",
    "vscodevim.vim"
)

foreach ($ext in $extensions) {
    $installedExtensions | rg -iq $ext
    $found = $LASTEXITCODE -eq 0

    if (-not $found) {
        Write-Host "Installing $ext"
        code --install-extension $ext
    } else {
        Write-Host "Skipping $ext"
    }
}

# -----------------
# Docker
# -----------------
$installedWinget | rg -iq Docker.DockerDesktop
$found = $LASTEXITCODE -eq 0

if (-not $found) {
    Write-Host "Starting docker containers"
    Start-Job { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" } -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 60

    Get-ChildItem "$HOME\things\docker\docker-compose" | ForEach-Object {
        Push-Location $_.FullName
        docker compose up -d --force-recreate
        Pop-Location
    }
} else {
    Write-Host "Skipping Containers"
}

# -----------------
# Environment variables
# -----------------
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", (Resolve-Path "$HOME\AppData\Local\Programs\Git\usr\bin\file.exe").Path, "User")
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", (Resolve-Path "$HOME\.config").Path, "User")
[Environment]::SetEnvironmentVariable("EZA_CONFIG_DIR", (Resolve-Path "$HOME\.config\eza").Path, "User")

