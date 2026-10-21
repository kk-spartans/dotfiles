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
  ];


  home.packages =
    with pkgs;
    [
      psmisc
      ripgrep
      immich-go
      sqlite
      bc
      cage
      fkill
      discrawl
    ]
    ++ lib.optionals (!minimal) [
      terminal-browser
      pwgen
      kitty
    ];
}
