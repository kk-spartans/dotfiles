param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

if ($Args.Count -lt 2) {
    throw 'cp needs at least a source and a destination'
}

$dest = $Args[-1]
$sources = $Args[0..($Args.Count - 2)]

foreach ($src in $sources) {
    Copy-Item -Path $src -Destination $dest -Recurse
}
