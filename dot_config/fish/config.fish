~/.local/bin/mise activate fish | source

fish_add_path -m ~/.local/bin ~/bin

if status is-interactive
    zoxide init fish | source

    function cd --description "cd uses zoxide; no args goes up one level"
        if test (count $argv) -eq 0
            builtin cd -
            return
        end

        z $argv
    end

    thefuck --alias | source
end

