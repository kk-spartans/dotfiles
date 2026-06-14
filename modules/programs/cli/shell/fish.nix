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
    ];

    programs.zellij = {
      enable = true;
      enableFishIntegration = false; # breaks my tty too...
      settings = {
        show_startup_tips = false;
        allow_kitty_graphics = true;
      };
    };

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
