$cliArgs = @()
$offset = 0

if ($args.Count -gt 0 -and -not $args[0].StartsWith('-')) {
    $cliArgs += '--prompt'
    $cliArgs += $args[0]
    $offset = 1
}

if ($args.Count -gt $offset -and -not $args[$offset].StartsWith('-')) {
    $cliArgs += '--model'
    $cliArgs += $args[$offset]
    $offset += 1
}

for ($i = $offset; $i -lt $args.Count; $i++) {
    $cliArgs += $args[$i]
}

opencode @cliArgs
