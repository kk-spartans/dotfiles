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

  # i have an idea for this i want to execute later:

  # images - kitten icat
  # markdown - glow
  # plaintext - bat
  # binary - hexyl
  # directories - eza
  # no args - eza
  # if only one file in dir, execute whatever is needed for it, and display the filename relative to the dir (in case of recursion) if the cli won't (bat and hexyl do)

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
