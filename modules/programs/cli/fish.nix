{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.kk-spartans.shell = pkgs.fish;
  users.users.kk-spartans.ignoreShellProgramCheck = true; # doesn't check home-manager

  home-manager.users.kk-spartans = {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';

      shellAliases.cp = "cp -r";
    };

    home.shell.enableFishIntegration = true;
    catppuccin.fish.enable = true;
  };
}
