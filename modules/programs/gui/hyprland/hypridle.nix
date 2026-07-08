{
  pkgs,
  inputs,
  lib,
  laptop,
  ...
}:
let
  dimDisplayIfOnBattery = pkgs.writeShellScript "hypridle-dim-display-if-on-battery" ''
    is_on_battery() {
      local supply type online
      for supply in /sys/class/power_supply/*; do
        type="$supply/type"
        online="$supply/online"

        [ -e "$type" ] || continue
        case "$(${pkgs.coreutils}/bin/cat "$type")" in
          Mains|USB|USB_C|USB_PD)
            [ -e "$online" ] && [ "$(${pkgs.coreutils}/bin/cat "$online")" = "1" ] && return 1
            ;;
        esac
      done

      return 0
    }

    state_dir="''${XDG_RUNTIME_DIR:-/tmp}/hypridle"
    marker="$state_dir/display-dimmed"

    if is_on_battery; then
      ${pkgs.coreutils}/bin/mkdir -p "$state_dir"
      ${pkgs.brightnessctl}/bin/brightnessctl -s set 0 && ${pkgs.coreutils}/bin/touch "$marker"
    fi
  '';

  restoreDisplayIfDimmed = pkgs.writeShellScript "hypridle-restore-display-if-dimmed" ''
    state_dir="''${XDG_RUNTIME_DIR:-/tmp}/hypridle"
    marker="$state_dir/display-dimmed"

    if [ -e "$marker" ]; then
      ${pkgs.brightnessctl}/bin/brightnessctl -r
      ${pkgs.coreutils}/bin/rm -f "$marker"
    fi
  '';
in
{
  config = lib.mkMerge [
    (lib.mkIf laptop {
      home.packages = [ pkgs.hypridle ];
      systemd.user.services.hypridle = {
        Unit = {
          Description = "Hyprland idle daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.hypridle}/bin/hypridle";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      xdg.configFile."hypr/hypridle.conf".text = ''
        listener {
            timeout = 30
            on-timeout = ${dimDisplayIfOnBattery}
            on-resume = ${restoreDisplayIfDimmed}
        }

        listener { 
            timeout = 32
            on-timeout = brightnessctl -d tpacpi::kbd_backlight -s set 0
            on-resume = brightnessctl -d tpacpi::kbd_backlight -r
        }

        listener {
            timeout = 60
            on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'
            on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
        }

        listener {
            timeout = 1800
            on-timeout = systemctl hibernate
        }
      '';
    })
  ];
}
