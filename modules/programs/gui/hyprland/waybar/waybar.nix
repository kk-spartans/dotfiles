{
  lib,
  laptop,
  gpu,
  pkgs,
  inputs,
  ...
}:
{
  catppuccin.waybar = {
    enable = true;
    mode = "createLink";
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar -l info";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.layer_rule({
        match = { namespace = "waybar" },
        animation = "slide top",
      })
    '';
  };

  xdg.configFile."waybar/vram.sh" = {
    source = ./vram.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;
    style = lib.mkForce ./style.css;
    settings = [
      {
        position = "top";
        margin-top = 5;

        modules-left = [
          "hyprland/workspaces"
          "custom/clock"
          "mpris"
          "custom/media-prev"
          "custom/media-next"
        ];
        modules-center = [ "tray" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "custom/ram"
        ]
        ++ lib.optionals (gpu == "nvidia") [
          "custom/vram"
        ]
        ++ lib.optionals laptop [
          "battery"
        ]
        ++ [
          "custom/notification"
        ];

        clock = {
          interval = 1;
          format = "{:%-I:%M:%S %a %d} ";
          tooltip = false;
          actions = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        "custom/clock" = {
          exec = "while true; do date +'%-I:%M:%S %a %d'; sleep 1; done";
          format = "{} ";
          tooltip = false;
        };

        mpris = {
          format = "{title}";
          format-paused = "{title}";
          tooltip = false;
          interval = 5;
          max-length = 20;
        };

        "hyprland/workspaces" = {
          format = "{name}";
          # format = "{name} {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "active" = "";
            "default" = "";
          };
        };

        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
        };

        "pulseaudio" = {
          "format" = "{icon} {volume} ";
          "format-bluetooth" = "{icon} {volume}";
          "format-muted" = " {volume} ";
          "format-icons" = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "phone-muted" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
            ];
          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
          "ignored-sinks" = [ "Easy Effects Sink" ];
        };
        "network" = {
          "interface" = "wlp9s0";
          "format" = "{essid}";
          "format-wifi" = " {essid}";
          "format-ethernet" = "{ipaddr}/{cidr} 󰊗";
          "format-disconnected" = "";
          "tooltip" = false;
          "max-length" = 80;
        };
        "cpu" = {
          "format" = "{usage} ";
        };
        "custom/ram" = {
          "exec" = "free -b | awk '/Mem:/ {printf \"%.1f\", $3/1024/1024/1024}'";
          "interval" = 10;
          "format" = "{} ";
          "tooltip" = false;
        };
        "custom/vram" = {
          "exec" = "~/.config/waybar/vram.sh";
          "interval" = 10;
          "format" = "{} 󰾲";
          "tooltip" = false;
        };

        "battery" = {
          "format" = "{capacity} {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
          "max-length" = 25;
        };

        "custom/media-prev" = {
          format = "";
          tooltip = false;
          on-click = "playerctl previous";
        };
        "custom/media-next" = {
          format = "";
          tooltip = false;
          on-click = "playerctl next";
        };
        "custom/notification" = {
          "tooltip" = true;
          "format" = "<span size='16pt'>{icon}</span>";
          "format-icons" = {
            "notification" = "󱅫";
            "none" = "󰂜";
            "dnd-notification" = "󰂠";
            "dnd-none" = "󰪓";
            "inhibited-notification" = "󰂛";
            "inhibited-none" = "󰪑";
            "dnd-inhibited-notification" = "󰂛";
            "dnd-inhibited-none" = "󰪑";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };
      }
    ];
  };
}
