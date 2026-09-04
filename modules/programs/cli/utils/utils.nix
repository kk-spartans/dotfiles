{
  config,
  lib,
  pkgs,
  inputs,
  minimal,
  ...
}:
{
  imports = [
    # ./lazy.nix
    ./tokscale.nix
    ./fast-cli.nix
    ./gogcli.nix
  ]
  ++ lib.optionals (!minimal) [
    ./ocrmypdf.nix
    ./totp-cli.nix
    inputs.nix-packages.homeManagerModules.terminal-agent-browser
  ];

  # Per-herdr-tab agent control for terminal-browser. Same toggle pattern as
  # the terminal-browser package above: off on minimal hosts.
  programs.terminal-agent-browser.enable = !minimal;

  home.packages =
    with pkgs;
    [
      psmisc
      ripgrep
      immich-go
      sqlite
      bc
      cage
      spogo
      fkill
      wacli
      discrawl
      hf
    ]
    ++ lib.optionals (!minimal) [
      terminal-browser
      pwgen
      kitty
    ];
}
