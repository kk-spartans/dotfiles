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

    imports = [
      ./view.nix
      ./fzf.nix
      ./trash.nix
    ];

    home.packages = with pkgs; [
      usage
      tldr
      inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr
    ];

    catppuccin.zellij.enable = true;

    programs.fastfetch.enable = true;
    programs.pay-respects.enable = true;

    programs.zoxide.enable = true;
    programs.fish.shellAliases.cd = "z";

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
