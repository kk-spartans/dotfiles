{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    ./delta.nix
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    attributes = [ "* text=auto eol=lf" ];

    settings = {
      user = {
        name = "Karthikeyan KK";
        email = "kcube.jan+github@gmail.com";
      };

      core = {
        autocrlf = "input";
        eol = "lf";
        longpaths = true;
      };

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "normal";
        submoduleSummary = true;
      };

      commit.gpgsign = true;

      gpg = {
        format = "openpgp";
        program = "gpg";
      };

      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";

      init.defaultBranch = "main";

      pull.rebase = true;
      push.autoSetupRemote = true;
      receive.denyNonFastForwards = true;
      rebase.autoStash = true;
    };
  };

  programs.gh.enable = true;

  home.packages = with pkgs; [
    gitoxide
  ];
}
