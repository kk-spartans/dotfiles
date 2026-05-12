param(
    [Parameter(Mandatory=$false, Position=0)]
    [string]$m = 'wip'
)

git.exe add --all
git.exe commit -S -m $m
if ($LASTEXITCODE -ne 0) {
    return
}

git.exe pull --rebase
if ($LASTEXITCODE -ne 0) {
    return
}

git.exe push
git.exe status
