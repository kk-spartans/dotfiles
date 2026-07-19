{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableMcpIntegration = true;
    };
  };

  programs.vicinae.settings.providers.applications.entrypoints.code.alias = "code";

  programs.git.settings = {
    mergetool.vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
    merge.tool = "vscode";
    core.editor = "code --wait";
  };
}
