param(
    [Parameter(Position=0)]
    [string]$Path = '.'
)

if ($Path -like '~*') {
    $Path = $Path -replace '^~', $HOME
}

eza --all --git --icons --group-directories-first $Path
