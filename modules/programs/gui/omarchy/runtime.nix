# Packaging for the vendored Omarchy runtime in ./src.
#
# The runtime derivation assembles the classic /usr/share/omarchy tree inside
# the store and wraps every command with a PATH closure, so the scripts behave
# exactly like their Arch counterparts: OMARCHY_PATH resolves to the store
# copy, sibling commands resolve through $out/bin wrappers, and every external
# tool they shell out to is on PATH.

{
  pkgs,
  lib,
  ...
}:
let
  src = ./src;

  # Every external binary the vendored commands may exec. Derived from a full
  # sweep of src/bin + src/shell + src/default; Arch-only tooling (pacman,
  # limine, mkinitcpio, snapper, plymouth) has no consumers left after the
  # curation pass, so it is deliberately absent here.
  omarchyTools = pkgs.buildEnv {
    name = "omarchy-tools";
    pathsToLink = [ "/bin" ];
    ignoreCollisions = true;
    postBuild = ''
      # The shell IPC helper execs `qs`, upstream quickshell's alternate name.
      ln -sf ${pkgs.quickshell}/bin/quickshell $out/bin/qs
    '';
    paths = with pkgs; [
      bash
      gum
      jq
      gawk
      gnugrep
      gnused
      findutils
      coreutils
      util-linux
      procps
      psmisc
      perl
      python3

      curl
      git
      fzf
      fastfetch
      lua
      tmux
      mise

      quickshell
      inotify-tools


      # capture suite
      grim
      slurp
      hyprpicker
      gpu-screen-recorder
      wl-clipboard
      wtype
      socat
      ffmpeg
      mpv
      v4l-utils
      tesseract
      zbar

      # theming / display
      imagemagick
      vips # vipsthumbnail for the image picker/menu
      ddcutil
      brightnessctl
      hyprsunset
      playerctl

      # network / hardware status
      networkmanager
      iproute2
      iw
      qrencode
      iputils
      tailscale

      # desktop plumbing
      fontconfig
      xdg-utils
      xdg-terminal-exec
      desktop-file-utils
      glib
      bluez
      upower
      uwsm
    ];
  };

  runtime = pkgs.stdenv.mkDerivation {
    pname = "omarchy";
    version = "unstable-2026-08-26";

    inherit src;

    nativeBuildInputs = with pkgs; [
      makeWrapper
      bash
      python3 # patchShebangs target for bin/omarchy-file-select
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/omarchy
      cp -r bin shell themes default applications logo.txt logo.svg icon.txt icon.png \
        $out/share/omarchy/
      chmod -R u+w $out/share/omarchy

      # omarchy-file-select ships a `#!/usr/bin/python3` shebang.
      chmod +x $out/share/omarchy/bin/*
      patchShebangs $out/share/omarchy/bin
      patchShebangs $out/share/omarchy/shell/plugins

      mkdir -p $out/bin
      for script in $out/share/omarchy/bin/*; do
        name=$(basename "$script")
        makeWrapper "$script" "$out/bin/$name" \
          --set OMARCHY_PATH "$out/share/omarchy" \
          --prefix PATH : "$out/share/omarchy/bin" \
          --prefix PATH : "${omarchyTools}/bin"
      done

      runHook postInstall
    '';

    passthru = {
      inherit omarchyTools;
      shellDir = "${runtime}/share/omarchy/shell";
    };

    meta = {
      description = "Omarchy look-and-feel runtime (Hyprland shell, themes, commands) for NixOS";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };
in
{
  environment.systemPackages = [
    runtime
    omarchyTools
  ];

  environment.sessionVariables.OMARCHY_PATH = "${runtime}/share/omarchy";

  # WebP backgrounds etc. for every Qt app, including quickshell whose own
  # wrapper prepends its plugin paths after this.
  environment.variables.QT_PLUGIN_PATH = "${pkgs.qt6.qtimageformats}/lib/qt-6/plugins";
}
