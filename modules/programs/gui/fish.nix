{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.wl-clipboard ];
  programs.fish.functions = {
    copy = ''
      command cat $argv | wl-copy
    '';

    cpf = ''
      for f in $argv
          if test -e "$f"
              printf "file://%s\n" (realpath "$f")
          end
      end | wl-copy -t text/uri-list
    '';
  };
}
