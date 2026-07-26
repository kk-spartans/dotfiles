{
  config,
  lib,
  pkgs,
  inputs,
  minimal,
  ...
}:
let
  npkgs = inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system};
in
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
      cage # useful on headless raspis

      npkgs.spogo
      npkgs.fkill
      npkgs.wacli
      npkgs.discrawl
      npkgs.hf
    ]
    ++ lib.optionals (!minimal) [
      pwgen
    ];
}
