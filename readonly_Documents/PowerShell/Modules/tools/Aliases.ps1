# === Remove default aliases and set custom ones ===
Remove-Item Alias:rm -ErrorAction SilentlyContinue
Remove-Item Alias:ls -ErrorAction SilentlyContinue
Remove-Item Alias:cat -ErrorAction SilentlyContinue
Remove-Item Alias:cd -ErrorAction SilentlyContinue
Remove-Item Alias:gc -ErrorAction SilentlyContinue
Remove-Item Alias:sc -ErrorAction SilentlyContinue

Set-Alias pb Get-Clipboard
Set-Alias sc Set-Clipboard

# Standard binaries
function node { mise x node -- node $args }
function npm { mise x node -- npm $args }
function npx { mise x node -- npx $args }
function pnpm { mise x node -- pnpm $args }
function pnpx { mise x node -- pnpm dlx $args}
function  bun { mise x bun -- bun $args }
function age { mise x age -- age $args }
function fastfetch { mise x fastfetch -- fastfetch $args }
function hyperfine { mise x hyperfine -- hyperfine $args }
function cloc { mise x cloc -- cloc $args }
function lazydocker { mise x lazydocker -- lazydocker $args }
function lazygit { mise x lazygit -- lazygit $args }
function gitleaks { mise x gitleaks -- gitleaks $args }
function delta { mise x delta -- delta $args }
function fd { mise x fd -- fd $args }
function magick { mise x imagemagick -- magick $args } # ImageMagick v7+ uses 'magick'
function jq { mise x jq -- jq $args }
function bat { mise x bat -- bat $args }
function fzf { mise x fzf -- fzf $args }
function zoxide { mise x zoxide -- zoxide $args }
function uv { mise x uv -- uv $args }
function uvx { mise x uv -- uvx $args }
function ffmpeg { mise x ffmpeg -- ffmpeg $args }
function glow { mise x glow -- glow $args }
function pandoc { mise x pandoc -- pandoc $args }

# Tools with name mismatches
function cargo { mise x rust -- cargo $args }  # Rust package provides cargo
function go { mise x go -- go $args }
function adb { mise x android-platform-tools -- adb $args }
function gh { mise x github-cli -- gh $args }

function trex { mise x go:github.com/samyakbardiya/trex -- trex $args }
function ascii-image-converter { mise x go:github.com/TheZoraiz/ascii-image-converter -- ascii-image-converter $args }

function bob { mise x cargo:bob-nvim -- bob $args }
function gix { mise x cargo:gitoxide -- gix $args } # gitoxide binary is usually 'gix' or 'ein'

function vercel { mise x bun -- bunx vercel $args }
function biome { mise x bun -- bunx biome $args }
function opencode { mise x bun -- bunx opencode $args } # Assuming the AI agent

function yt-dlp { mise x uv -- uvx yt-dlp $args }
function spotdl { mise x uv -- uvx spotdl $args }
function ocrmypdf { mise x uv -- uvx ocrmypdf $args }
function copyparty { mise x uv -- uvx copyparty $args }
function mcpo { mise x uv -- uvx mcpo $args }
function tldr { mise x uv -- uvx tldr $args }
function xonsh { mise x uv -- uvx xonsh $args }
function oterm { mise x uv -- uvx oterm $args }
function pycowsay { mise x uv -- uvx pycowsay $args }
function oh-my-posh { mise x github:JanDeDobbeleer/oh-my-posh -- oh-my-posh $args }

