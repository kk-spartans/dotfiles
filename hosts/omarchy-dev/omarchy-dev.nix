{
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # The Omarchy layer lives here alone until sign-off, then moves into
    # modules/programs/gui/gui.nix for every pc host.
    ../../modules/programs/gui/omarchy/omarchy.nix
  ];

  # GUI test rig for the Omarchy layer: same pc chain as kk-spartans,
  # minus real-hardware concerns (NVIDIA, TLP battery logic is inert here).

  # Demo tooling: in-guest screen recording for the verification clip.
  environment.systemPackages = [ pkgs.wf-recorder pkgs.v4l-utils ];

  # The real host logs into tty1 by hand and fish starts uwsm; the rig needs
  # an unattended seat for the demo recording.
  services.getty.autologinUser = "kk-spartans";

  # No display manager here: uwsm waits for graphical.target before handing
  # over to Hyprland, so let tty1 pull the target up.
  systemd.targets.graphical.wants = [ "getty@tty1.service" ];

  # uwsm prompts with a session picker when no default is configured.
  home-manager.users.kk-spartans.home.sessionVariables.UWSM_DEFAULT_SESSION = "hyprland-uwsm";

  # The real host's fish init races graphical.target on this rig (no DM
  # brings it up); wait for it before handing over to uwsm.
  home-manager.users.kk-spartans.programs.fish.loginShellInit = ''
    if test "$(tty)" = /dev/tty1
      while ! systemctl is-active -q graphical.target; sleep 1; end
      uwsm start hyprland-uwsm.desktop
    end
  '';


  # Headless inspection of the running VM.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  virtualisation.vmVariant.virtualisation.forwardPorts = [
    {
      from = "host";
      host.port = 2222;
      guest.port = 22;
    }
  ];
}
