{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./extensions.nix
    ./search.nix
    ./mods.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    extraPrefsFiles = [
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
        sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
      })
    ];

    policies = {
      DontCheckDefaultBrowser = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };
}
