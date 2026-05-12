{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.bat = {
    enable = true;
    config = {
      paging = "never";
      style = "full";
      wrap = "auto";
      color = "always";
      theme = "Catppuccin Mocha";
    };
  };

  home.packages = [ pkgs.glow ];
  catppuccin.bat.enable = true;

  programs.fish = {
    functions.rat = ''
          for target in $argv
              if test "$target" = "-"
                  command bat -
              else if string match -rq -- '\.(md)$' "$target"
                  command glow "$target"
              else
                  command bat "$target"
              end
          end
    '';

    shellAliases = {
      cat = "rat"; # defining it directly breaks colors in my shell for some reason
      pcat = "command cat";
    };
  };
}
