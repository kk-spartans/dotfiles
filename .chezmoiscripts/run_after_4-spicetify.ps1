if (-not (Get-Command spicetify -ErrorAction SilentlyContinue)) {
    iwr -useb https://gist.githubusercontent.com/kk-spartans/56278494b3b9e7be49e44b3e610b2283/raw/df44647e0f1631f15bb9890e0b62dccb2b3e5747/install.ps1 | iex
}