# Theme engine wiring: fonts, first-login theme activation.
#
# The engine itself is vendored bash (omarchy-theme-set and friends). This
# module only makes sure it has what it needs on first login.

{
  lib,
  pkgs,
  config,
  ...
}:
let
  omarchyFont = pkgs.stdenv.mkDerivation {
    pname = "omarchy-icon-font";
    version = "1.0";
    src = ./src/default/fonts/omarchy;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -Dm644 omarchy.ttf $out/share/fonts/truetype/omarchy/omarchy.ttf
      runHook postInstall
    '';
    meta.license = lib.licenses.unfreeRedistributable;
  };
in
{
  # omarchy.ttf carries the bar/menu glyph set; Noto covers general UI text.
  fonts.packages = [
    omarchyFont
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
  ];

  home-manager.users.kk-spartans =
    let
      themeSet = "${config.environment.sessionVariables.OMARCHY_PATH}/bin/omarchy-theme-set";
    in
    {
      # First graphical login renders catppuccin into
      # ~/.local/state/omarchy/current/; later switches happen live through the
      # menu/theme picker. Re-running after a rebuild is a no-op once state
      # exists, so this stays cheap forever.
      systemd.user.services.omarchy-theme-init = {
        Unit = {
          Description = "Apply the default Omarchy theme if none is active yet";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c '[ -f %h/.local/state/omarchy/current/theme/colors.toml ] || ${themeSet} catppuccin'";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
