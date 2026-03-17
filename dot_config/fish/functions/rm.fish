function rm --description "Trash paths instead of deleting"
    for path in $argv
        command trash "$path" --verbose 2>/dev/null
        or true
    end
end
