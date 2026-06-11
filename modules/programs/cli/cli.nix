{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./fish.nix
    ./nix/nix.nix
    ./docker.nix
    ./tailscale.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";

  services.devmon.enable = true;
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.dbus.implementation = lib.mkForce "dbus";
  security.rtkit.enable = true;
  programs.usbtop.enable = true;

  home-manager.users.kk-spartans = {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      inputs.catppuccin.homeModules.catppuccin
      ./skills.nix
      ./crypto.nix
      ./opencode.nix
      ./btop.nix
      ./git/git.nix
      ./view.nix
      ./fd.nix
      ./fzf.nix
      ./lazy.nix
      ./hf.nix
      ./javascript.nix
      ./rust.nix
      ./python.nix
      ./trash.nix
      ./zoxide.nix
      ./spogo.nix
      ./fkill.nix
      ./ocrmypdf.nix
      ./tokscale.nix
      ./wacli.nix
      ./zellij.nix
      ./totp-cli.nix
      ./fast-cli.nix
      ./llms.nix
      ./agent-browser.nix # nixpkgs doesn't have latest
    ];

    home.packages = with pkgs; [
      psmisc
      pwgen
      perl
      tree
      wget
      ripgrep
      ffmpeg
      tshark
      yt-dlp
      sox
      age
      jq
      hyperfine
      pandoc
      aria2
      aube
      gitoxide
      diskus
      immich-go
      gogcli
      rclone
      rsync
      ansi2html
      copyparty-full-buggy
      img2pdf
      mitmproxy
      spotdl
      tldr
      iperf3
      cloc
      sqlite
      pi-coding-agent
      scrcpy
      cage # useful on headless raspis
      dig
      mesa-demos # glxinfo
      devenv
      usage
    ];

    programs.neovim.enable = true;
    programs.pay-respects.enable = true;
    programs.go.enable = true;
    programs.fastfetch.enable = true;
    programs.home-manager.enable = true;
  };
}
