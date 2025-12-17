Set-Location $env:userprofile/.local/share/chezmoi/.hidden/dotfiles/
cargo build --release
target/release/dotfiles.exe