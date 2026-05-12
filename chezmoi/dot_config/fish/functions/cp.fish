function cp --description "Copy recursively with cp -r"
    if test (count $argv) -lt 2
        echo "cp needs at least a source and a destination" >&2
        return 1
    end

    command cp -r $argv
end
