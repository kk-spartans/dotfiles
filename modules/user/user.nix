{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./locale.nix
    ./networking.nix
    ./sops.nix
  ];

  sops.templates."nix/netrc".content = ''
    machine github.com login x-access-token password ${config.sops.placeholder.GITHUB_TOKEN}
  '';

  nix.settings = {
    trusted-users = [
      "root"
      "kk-spartans"
    ];

    netrc-file = config.sops.templates."nix/netrc".path;
  };

  sops.secrets.GITHUB_TOKEN = { };

  users.users.kk-spartans = {
    isNormalUser = true;
    description = "Karthikeyan KK";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
      "video"
      "dialout"
    ];
    initialPassword = "123456789"; # pls change
  };

  users.groups.uinput = { };

  # Plain `sudo` resolves via /run/wrappers/bin (setuid wrappers, first in
  # PATH on login shells via /etc/profile). /run/current-system/sw/bin/sudo
  # is the raw store copy without setuid and always fails with "must be owned
  # by uid 0 and have the setuid bit set" when it shadows the wrapper (e.g.
  # in non-login shells with a custom PATH that never sourced /etc/profile).
  # Nothing is broken system-side; this pins the intent.
  security.sudo.enable = true;

  security.sudo.extraRules = [
    {
      users = [ "kk-spartans" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    users.kk-spartans = {
      home.username = "kk-spartans";
      home.homeDirectory = "/home/kk-spartans";
      home.stateVersion = "26.11";

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
