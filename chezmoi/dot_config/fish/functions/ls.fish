function ls --description "List with eza defaults"
    set -l path .
    if test (count $argv) -ge 1
        set path "$argv[1]"
    end

    if string match -rq -- '^~' "$path"
        set path (string replace -r '^~' "$HOME" -- "$path")
    end

    command eza --all --git --icons --group-directories-first "$path"
end
