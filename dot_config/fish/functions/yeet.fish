function yeet --description "Force remove paths"
    for path in $argv
        command rm -rf -- "$path" 2>/dev/null
        or true
    end
end
