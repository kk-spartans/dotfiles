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
    hooks.pre-commit = pkgs.writeShellScript "pre-commit" ''
      #!/usr/bin/env bash
      gitleaks git --pre-commit --verbose
    '';

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
  home.packages = [ pkgs.gitleaks ];
}
