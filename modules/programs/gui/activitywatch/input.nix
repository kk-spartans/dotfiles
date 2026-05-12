{
  pkgs,
  inputs,
  ...
}:
{
  services.activitywatch.watchers.aw-watcher-input.package =
    pkgs.python313Packages.buildPythonApplication
      {
        pname = "aw-watcher-input";
        version = "0.1.0";
        src = inputs.aw-watcher-input;
        pyproject = true;
        build-system = [ pkgs.python313Packages.poetry-core ];
        dependencies = [
          pkgs.python313Packages.aw-client
          pkgs.aw-watcher-afk
        ];
        meta.mainProgram = "aw-watcher-input";
      };
}
