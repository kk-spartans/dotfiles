{
  pkgs,
  inputs,
  ...
}:
{
  services.activitywatch.watchers.aw-watcher-netstatus.package =
    pkgs.python313Packages.buildPythonApplication
      {
        pname = "aw-watcher-netstatus";
        version = "1.0.1";
        src = inputs.aw-watcher-netstatus;
        pyproject = true;
        build-system = [ pkgs.python313Packages.poetry-core ];
        dependencies = with pkgs.python313Packages; [
          aw-client
          aw-core
        ];
        meta.mainProgram = "aw-watcher-netstatus";
      };
}
