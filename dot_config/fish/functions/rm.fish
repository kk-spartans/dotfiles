function rm --description "Trash paths instead of deleting"
    for path in $argv
        command gomi "$path"
        or true
    end
end
