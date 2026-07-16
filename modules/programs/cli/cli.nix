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
    ./nix/nix.nix
    ./shell/fish.nix

    ./benchmarking.nix
    ./docker.nix
    ./tailscale.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-40.10.5"
  ];
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.11";

  services.devmon.enable = true;
  services.openssh.enable = true;
  security.rtkit.enable = true;

  services.dbus = {
    enable = true;
    implementation = lib.mkForce "dbus";
  };

  home-manager.users.kk-spartans = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin

      ./llms/llms.nix
      ./dev/dev.nix
      ./git/git.nix

      ./files.nix
      ./media.nix
      ./networking.nix
      ./utils/utils.nix
    ];

    catppuccin.autoEnable = false;
    programs.home-manager.enable = true;
  };
}
