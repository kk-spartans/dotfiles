mise activate fish | source
brew shellenv fish | source

if status is-interactive
    zoxide init fish | source

    function cd --description "cd uses zoxide; no args goes previous dir"
        if test (count $argv) -eq 0
            if set -q OLDPWD; and test -n "$OLDPWD"
                builtin cd - 2>/dev/null
                or builtin cd
            else
                builtin cd
            end
            return
        end

        z $argv
    end

    thefuck --alias | source
end

