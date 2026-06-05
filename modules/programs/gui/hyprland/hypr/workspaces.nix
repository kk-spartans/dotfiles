{
  ...
}:
let
  moveBinds = builtins.concatStringsSep "\n" (
    builtins.map (n: ''
      hl.bind("SUPER + SHIFT + ${toString n}", hl.dsp.window.move({ workspace = ${toString n} }))
    '') (builtins.genList (i: i + 1) 9)
  );
  focusBinds = builtins.concatStringsSep "\n" (
    builtins.map (n: ''
      hl.bind("SUPER + ${toString n}", hl.dsp.focus({ workspace = ${toString n} }))
    '') (builtins.genList (i: i + 1) 9)
  );
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${moveBinds}
    hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

    ${focusBinds}
    hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
  '';
}
