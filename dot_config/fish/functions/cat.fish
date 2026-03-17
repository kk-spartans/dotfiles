function cat --description "Pretty print files via bat/glow"
    function __cat_show_file --no-scope-shadowing
        set -l target $argv[1]

        if test "$target" = "-"
            command bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" -
            return
        end

        if string match -rq -- '\.(md|markdown)$' "$target"
            command glow "$target"
        else
            command bat --paging=never --style=full --wrap=never --color=always --theme="Catppuccin Mocha" "$target"
        end
    end

    for input in $argv
        set -l path $input
        if string match -rq -- '^~' "$path"
            set path (string replace -r '^~' "$HOME" -- "$path")
        end

        set -l matches $path
        if test (count $matches) -eq 0
            continue
        end

        for target in $matches
            if test -d "$target"
                for file in "$target"/*
                    if test -f "$file"
                        __cat_show_file "$file"
                    end
                end
                continue
            end

            if test -e "$target"
                __cat_show_file "$target"
            end
        end
    end

    functions --erase __cat_show_file
end
