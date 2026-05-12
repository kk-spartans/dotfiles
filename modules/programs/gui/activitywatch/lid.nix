{
  pkgs,
  inputs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  lidSettings = {
    enable_boot_detection = true;
    boot_gap_threshold = 300.0;
    journal_poll_interval = 60.0;
  };
in
{
  services.activitywatch.watchers.aw-watcher-lid = {
    package = pkgs.writeShellApplication {
      name = "aw-watcher-lid";
      runtimeInputs = [
        (pkgs.python313.withPackages (ps: [
          ps.aw-client
          ps.dbus-python
          ps.pygobject3
        ]))
      ];
      text = ''
        if [ -n "''${PYTHONPATH-}" ]; then
          export PYTHONPATH="${inputs.aw-watcher-lid}:$PYTHONPATH"
        else
          export PYTHONPATH="${inputs.aw-watcher-lid}"
        fi
        exec python -m aw_watcher_lid "$@"
      '';
    };
    executable = "aw-watcher-lid";
  };

  xdg.configFile."aw-watcher-lid/aw-watcher-lid.toml".source =
    tomlFormat.generate "aw-watcher-lid-config" lidSettings;
}
