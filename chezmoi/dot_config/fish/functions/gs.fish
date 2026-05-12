function gs --description "Git add/commit/pull --rebase/push/status"
    argparse 'm=' -- $argv
    or return

    set -l msg wip
    if set -q _flag_m
        set msg "$_flag_m"
    else if test (count $argv) -gt 0
        set msg (string join ' ' -- $argv)
    end

    command git add --all
    command git commit -S -m "$msg"
    if test $status -ne 0
        return
    end

    command git pull --rebase
    if test $status -ne 0
        return
    end

    command git push
    command git status
end
