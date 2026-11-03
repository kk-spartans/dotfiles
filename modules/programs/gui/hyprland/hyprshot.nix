{
  pkgs,
  inputs,
  ...
}:

let
  # hyprshot calls plain `hyprctl` internally, which resolves the Hyprland
  # instance from $HYPRLAND_INSTANCE_SIGNATURE. When several (stale) Hyprland
  # sockets exist, that variable can point at a dead instance, so `hyprctl`
  # returns nothing and hyprshot's jq `contains()` is empty -> jq parse error
  # -> no geometry -> nothing copied to the clipboard.
  #
  # This wrapper probes the sockets, exports the signature of the first live
  # instance, then runs the real hyprshot.
  hyprshot-live = pkgs.writeShellScriptBin "hyprshot-live" ''
    for sock in /run/user/$(id -u)/hypr/*/; do
      sig="$(basename "$sock")"
      if HYPRLAND_INSTANCE_SIGNATURE="$sig" hyprctl -j monitors >/dev/null 2>&1; then
        export HYPRLAND_INSTANCE_SIGNATURE="$sig"
        break
      fi
    done
    exec hyprshot "$@"
  '';

  # Patch hyprshot's broken `grab_window` jq:
  #   `.workspace.id | contains('1,2,3')` aborts on null workspace ids (special
  #   workspaces like Spotify) and on numeric ids ("number and string cannot
  #   have their containment checked"), so window mode never yields geometry.
  #   Replaced with an index() lookup against the monitor active-workspace ids.
  hyprshot = pkgs.hyprshot.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      sed -i -f ${./fix-hyprshot-grab-window.sed} $out/bin/.hyprshot-wrapped
    '';
  });
in
{
  home.packages = with pkgs; [
    hyprshot
    hyprshot-live
    satty
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("Print", hl.dsp.exec_cmd("hyprshot-live --freeze --mode region --clipboard-only --notif-timeout 3000"))
    hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot-live --freeze --mode region --clipboard-only --notif-timeout 3000 --raw | satty --filename -"))
    hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot-live --freeze --mode window --clipboard-only --notif-timeout 3000"))
    hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("hyprshot-live --freeze --mode window --clipboard-only --notif-timeout 3000 --raw | satty --filename -"))

    hl.layer_rule({
      name = "hyprshot-fade",
      match = { namespace = "hyprshot" },
      animation = "fade",
    })
  '';
}
