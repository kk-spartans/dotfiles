{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    # Under /etc, not under $HOME: the initrd activation runs setupSecrets
    # before /home is mounted, so a key in the home directory makes every
    # secret (and the nix netrc built from GITHUB_TOKEN) silently fail to
    # materialise.
    age.keyFile = "/etc/sops/age/keys.txt";
  };

  # Nix reads GitHub credentials from access-tokens, and nix.conf is generated
  # read-only from this config, so the token cannot live there without ending up
  # in git. sops decrypts it to a root-only file and a tiny service hands it to
  # the daemon before it starts. (netrc is not consulted for flake fetches.)
  sops.templates."nix-access-token".content = ''
    access-tokens = github.com=${config.sops.placeholder.GITHUB_TOKEN}
  '';

  systemd.services.nix-github-auth = {
    description = "Give nix credentials for private flake inputs";
    wantedBy = [ "nix-daemon.service" ];
    before = [ "nix-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.coreutils}/bin/install -d -m 700 /root/.config/nix
        ${pkgs.coreutils}/bin/install -m 600 ${config.sops.templates."nix-access-token".path} /root/.config/nix/nix.conf
      '';
    };
    # Re-copy if the decrypted secret ever changes.
    restartTriggers = [ config.sops.templates."nix-access-token".path ];
  };

  home-manager.users.kk-spartans = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = [ pkgs.sops ];

    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/etc/sops/age/keys.txt";
    };
  };
}
