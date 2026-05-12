{
  pkgs,
  inputs,
  ...
}:
let
  pythonEnv = pkgs.python313.withPackages (ps: [
    ps.aw-client
    ps.aw-core
    ps.psutil
  ]);
in
{
  services.activitywatch.watchers.aw-watcher-utilization = {
    package = pkgs.writeShellScriptBin "aw-watcher-utilization" ''
      export PYTHONPATH="${inputs.aw-watcher-utilization}:${pythonEnv}/${pkgs.python313.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}"
      exec ${pkgs.python313}/bin/python -c 'from aw_watcher_utilization import main; main()' "$@"
    '';
    executable = "aw-watcher-utilization";
  };
}
