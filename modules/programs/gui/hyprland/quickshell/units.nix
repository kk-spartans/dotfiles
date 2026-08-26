# User services ported from Omarchy's shipped systemd/user units.
#
# Translated into home-manager services so the store paths come from this
# closure instead of the /usr/bin assumptions in the upstream unit files.

{
  lib,
  pkgs,
  config,
  ...
}:
let
  runtime = config.environment.sessionVariables.OMARCHY_PATH;
in
{
  home-manager.users.kk-spartans = {
    # Bluetooth pairing agent (auto-accept while the panel is scanning).
    systemd.user.services.bt-agent = {
      Unit = {
        Description = "Bluetooth pairing agent (auto-accept)";
        After = [ "dbus.socket" ];
        Requires = [ "dbus.socket" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecCondition = "${pkgs.systemd}/bin/systemctl is-active --quiet bluetooth.service";
        ExecStart = "${pkgs.bluez-tools}/bin/bt-agent -c NoInputNoOutput";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    # Announce process crashes and offer an AI diagnosis terminal.
    systemd.user.services.omarchy-crash-watch = {
      Unit = {
        Description = "Announce process crashes and offer an AI diagnosis";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        ConditionPathExists = "!%h/.local/state/omarchy/toggles/crash-capture-off";
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${runtime}/bin/omarchy-crash-watch";
        Restart = "always";
        RestartSec = 5;
      };
    };

    # Recover the internal monitor toggle when no external display exists.
    systemd.user.services.omarchy-recover-internal-monitor = {
      Unit = {
        Description = "Recover the internal monitor toggle when no external display is connected";
        Before = [ "graphical-session-pre.target" ];
        ConditionPathExists = "%h/.local/state/omarchy/toggles/hypr/internal-monitor-disable.lua";
      };
      Install.WantedBy = [ "graphical-session-pre.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = "${runtime}/bin/omarchy-hw-recover-internal-monitor";
      };
    };

    # Save incoming Taildrop files to the downloads directory.
    systemd.user.services.omarchy-tailscale-receive = {
      Unit.Description = "Save incoming Taildrop files to the downloads directory";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${runtime}/bin/omarchy-tailscale-receive";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
