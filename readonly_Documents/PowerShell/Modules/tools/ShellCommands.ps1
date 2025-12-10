# === Fix ls command ===
function ls {
    param([string]$Path = '.')
    if ($Path -like '~*') { $Path = $Path -replace '^~', $HOME }
    eza --all --git --icons --group-directories-first $Path
}

# === Bat to Cat ===
function cat {
    param([string]$Path)
    if ($Path -like '~*') { $Path = $Path -replace '^~', $HOME }
    bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" $Path
}

# === cd command ===
function cd {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = '~'
    )
    z $Path
}
