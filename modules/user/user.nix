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

  environment.pathsToLink = [ "/sbin" ];

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
    ];
    initialPassword = "123456789"; # pls change
  };

  users.groups.uinput = { };

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
      home.stateVersion = "26.05";

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
