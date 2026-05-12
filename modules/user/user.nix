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
  ];

  nix.settings.trusted-users = [
    "root"
    "kk-spartans"
  ];
  users.users.kk-spartans = {
    isNormalUser = true;
    description = "Karthikeyan KK";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
    ];
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

    users.kk-spartans.home = {
      username = "kk-spartans";
      homeDirectory = "/home/kk-spartans";
      stateVersion = "26.05";

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
