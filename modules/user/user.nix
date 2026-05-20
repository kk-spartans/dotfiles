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

  nix.settings = {
  trusted-users = [
    "root"
    "kk-spartans"
  ];
  
  access-tokens = [ "github.com=${config.sops.secrets."GITHUB_TOKEN".path}" ];
  };

  sops.secrets.GITHUB_TOKEN = { };

  users.users.kk-spartans = {
    isNormalUser = true;
    description = "Karthikeyan KK";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
    ];
    initialPassword = "123456789"; # pls change
  };

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
