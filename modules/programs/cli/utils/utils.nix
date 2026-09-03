{
  config,
  lib,
  pkgs,
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
