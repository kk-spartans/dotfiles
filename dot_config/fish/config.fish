if status is-interactive
    function cd --description "cd uses zoxide; no args goes up one level"
        if test (count $argv) -eq 0
            builtin cd ..
            return
        end

        z $argv
    end

    zoxide init fish | source
    thefuck --alias | source
end

~/.local/bin/mise activate fish | source
