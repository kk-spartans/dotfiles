function oc --description "Run opencode with optional prompt/model positional args"
    set -l cli_args
    set -l i 1
    set -l argc (count $argv)

    if test $argc -ge 1
        if not string match -q -- '-*' "$argv[1]"
            set cli_args $cli_args --prompt "$argv[1]"
            set i 2
        end
    end

    if test $argc -ge $i
        if not string match -q -- '-*' "$argv[$i]"
            set cli_args $cli_args --model "$argv[$i]"
            set i (math $i + 1)
        end
    end

    while test $i -le $argc
        set cli_args $cli_args "$argv[$i]"
        set i (math $i + 1)
    end

    command opencode $cli_args
end
