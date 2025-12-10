# === Git Shortcut ===
function gs {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$m
    )
    git add --all
    git commit -m "$m"
    git push
    git pull
    git status
}
