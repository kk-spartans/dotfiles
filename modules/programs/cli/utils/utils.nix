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

    ./spogo.nix
    ./fkill.nix
    ./tokscale.nix
    ./wacli.nix
    ./fast-cli.nix
  ]
  ++ lib.optionals (!minimal) [
    ./ocrmypdf.nix
    ./hf.nix
    ./totp-cli.nix
  ];

  home.packages =
    with pkgs;
    [
      psmisc
      ripgrep
      immich-go
      gogcli
      sqlite
      cage # useful on headless raspis
    ]
    ++ lib.optionals (!minimal) [
      pwgen
    ];
}
