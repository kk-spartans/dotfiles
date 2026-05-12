{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./fish.nix
    ./nix-ld.nix
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
  security.rtkit.enable = true;
  programs.usbtop.enable = true;

  home-manager.users.kk-spartans = {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      ./skills.nix
      ./opencode.nix
      ./btop.nix
      ./git/git.nix
      ./bat.nix
      ./eza.nix
      ./fd.nix
      ./fzf.nix
      ./lazy.nix
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
      ./tmux.nix
      ./agent-browser.nix # nixpkgs doesn't have latest
    ];

    home.packages = with pkgs; [
      psmisc
      nixfmt
      treefmt
      perl
      tree
      wget
      ripgrep
      ffmpeg
      tshark
      nom
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
      hexyl
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
      fast-cli-zig
      nix-index
    ];

    programs.neovim.enable = true;
    programs.pay-respects.enable = true;
    programs.go.enable = true;
    programs.fastfetch.enable = true;
    programs.home-manager.enable = true;
  };
}
