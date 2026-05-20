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
      set -l recursive 0

      if test (count $argv) -gt 0 -a "$argv[1]" = "--recursive"
          set recursive 1
          set argv $argv[2..-1]
      end

            # no args → list current dir
      if test (count $argv) -eq 0
          eza
          return
      end

      for target in $argv
          # stdin
          if test "$target" = "-"
              bat -p -
              continue
          end

          # directory
          if test -d "$target"
              set files (ls -A "$target")

              if test (count $files) -eq 1
                  set single "$target/$files[1]"
                  c --recursive "$single"
              else
                  eza "$target"
              end
              continue
          end

          # file checks
          if test -f "$target"
              # markdown
              if string match -rq '\.(md)$' "$target"
                  if test $recursive -eq 1
                      echo "$target"
                  end

                  glow "$target"
                  continue
              end

              # image
              if string match -rq '\.(png|jpg|jpeg|gif|webp|bmp)$' "$target"
                  if test $recursive -eq 1
                      echo "$target"
                  end

                  kitten icat "$target"
                  continue
              end

              # binary vs text
              if file --mime "$target" | string match -rq 'charset=binary'
                  if test $recursive -eq 1
                      echo "$target"
                  end

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
