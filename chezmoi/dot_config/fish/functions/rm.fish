function rm --description "Trash paths instead of deleting"
    for path in $argv
        command gomi -f -r "$path"
        or true
    end
end
