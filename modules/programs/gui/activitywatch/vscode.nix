{
  programs.vscode.profiles.default.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "aw-watcher-vscode";
      publisher = "activitywatch";
      version = "0.5.0";
      sha256 = "sha256-OrdIhgNXpEbLXYVJAx/jpt2c6Qa5jf8FNxqrbu5FfFs=";
    }
  ];

}
