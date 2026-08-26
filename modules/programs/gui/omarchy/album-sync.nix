# Album-art adaptive theming.
#
# omarchy-album-sync reads the MPRIS currently-playing track, extracts the
# cover art's dominant palette, switches to the installed theme whose colors
# best match it, and re-tints the current background toward the album colors.
#
#   once    adapt to whatever is playing right now
#   follow  keep adapting on every track change; enable persistently by
#           touching ~/.local/state/omarchy/toggles/album-sync-on

{
  lib,
  pkgs,
  config,
  ...
}:
let
  runtime = config.environment.sessionVariables.OMARCHY_PATH;

  albumSync = pkgs.writeShellApplication {
    name = "omarchy-album-sync";
    runtimeInputs = with pkgs; [
      imagemagick
      playerctl
      curl
      coreutils
      gawk
      gnugrep
      runtime
    ];
    text = builtins.readFile ./album-sync.sh;
  };
in
{
  environment.systemPackages = [ albumSync ];

  home-manager.users.kk-spartans = {
    systemd.user.services.omarchy-album-follow = {
      Unit = {
        Description = "Follow the playing track's album art and adapt the Omarchy theme";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        ConditionPathExists = "%h/.local/state/omarchy/toggles/album-sync-on";
      };
      Service = {
        Type = "simple";
        ExecStart = "${albumSync}/bin/omarchy-album-sync follow";
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };
}
