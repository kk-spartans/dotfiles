{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    enableFishIntegration = false; # aliases ls to eza
    extraOptions = [
      "--group-directories-first"
      "--all"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      paging = "never";
      style = "full";
      wrap = "auto";
      color = "always";
    };
  };

  home.packages = with pkgs; [
    glow
    hexyl
    file
  ];

  catppuccin.bat.enable = true;
  catppuccin.eza.enable = true;

  # i have an idea for this i want to execute later:

  # images - kitten icat
  # markdown - glow
  # plaintext - bat
  # binary - hexyl
  # directories - eza
  # no args - eza
  # if only one file in dir, execute whatever is needed for it, and display the filename relative to the dir (in case of recursion) if the cli won't (bat and hexyl do)

  programs.fish = {
    functions.c = ''
            # no args → list current dir
      if test (count $argv) -eq 0
          eza
          return
      end

      for target in $argv
          # stdin
          if test "$target" = "-"
              bat -
              continue
          end

          # directory
          if test -d "$target"
              set files (ls -A "$target")

              if test (count $files) -eq 1
                  set single "$target/$files[1]"
                  echo "$single"

                  c "$single"
              else
                  eza "$target"
              end
              continue
          end

          # file checks
          if test -f "$target"
              # markdown
              if string match -rq '\.(md)$' "$target"
                  glow "$target"
                  continue
              end

              # image
              if string match -rq '\.(png|jpg|jpeg|gif|webp|bmp)$' "$target"
                  kitten icat "$target"
                  continue
              end

              # binary vs text
              if file --mime "$target" | string match -rq 'charset=binary'
                  hexyl "$target"
              else
                  bat "$target"
              end

              continue
          end

          # fallback (non-existent or weird stuff)
          echo "no idea what this is: $target"
      end
    '';
  };
}
