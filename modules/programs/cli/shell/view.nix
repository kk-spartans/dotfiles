{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.mpv.enable = true;
  catppuccin.mpv.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    enableFishIntegration = false; # aliases ls to eza by default

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

  programs.fish = {
    functions.c = ''
      set -l recursive 0

      if test (count $argv) -gt 0 -a "$argv[1]" = "--recursive"
          set recursive 1
          set argv $argv[2..-1]
      end

      if test (count $argv) -eq 0
          set argv .
      end

      for target in $argv
          # stdin
          if test "$target" = "-"
              bat -p -
              continue
          end

          # directory
          if test -d "$target"
              eza "$target"
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

              # video
              if string match -rq '\.(mp4|mkv|avi|mov|webm|m4v|ogv|wmv|flv)$' "$target"
                  if test $recursive -eq 1
                      echo "$target"
                  end

                  mpv "$target"
                  continue
              end

              # binary vs text
              if file -L --mime "$target" | string match -rq 'charset=binary'
                  if test $recursive -eq 1
                      echo "$target"
                  end

                  set size (stat -c%s $target)

                  hexyl $target
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
