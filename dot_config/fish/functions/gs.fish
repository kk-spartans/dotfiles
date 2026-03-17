function gs --description "Git add/commit/pull --rebase/push/status"
    if test (count $argv) -lt 1
        echo "Usage: gs <commit message>" >&2
        return 1
    end

    command git add --all
    and command git commit -S -m "$argv[1]"
    and command git pull --rebase
    and command git push
    and command git status
end
