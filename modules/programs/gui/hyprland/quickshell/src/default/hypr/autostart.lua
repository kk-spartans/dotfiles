hl.on("hyprland.start", function()
  -- Slow app launch fix -- set systemd vars before starting session services.
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")

  hl.exec_cmd("omarchy-launch-shell")
  -- Provisioning is handled declaratively by the NixOS/home-manager layer.
  hl.exec_cmd(o.launch("omarchy-hyprland-monitor-watch"))
  -- udiskie runs as a home-manager user service on this host.

  -- Run post-boot hooks after startup config has loaded.
  hl.exec_cmd("sleep 2 && omarchy-hook post-boot")
end)
