{
  config,
  pkgs,
  lib,
  ...
}:
# i split my config up based on vibes. and "audio" vibes with "bluetooth".
{
  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # i wouldn't wish this on *anyone*
    # when you pair an echo sphere (advertises itself as an "echo dot 21u"
    # to a nixos pc (thinkpad p15 gen 2i)
    # which advertises itself as a a2dp_sink
    # the speaker plays a noise you probably never heard before
    # and the alexa tts plays through your laptop speakers

    # my temporary solution was spotify connect
    # but it was janky

    # thanks to codex for giving me my sanity back

    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-bluetooth.conf" ''
        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_source ]
          bluez5.hfphsp-backend = "native"
          bluez5.enable-hw-volume = true
        }
      '')
    ];
  };

  home-manager.users.kk-spartans = {
    home.packages = with pkgs; [
      blueman
      pulseaudio
      hyprpwcenter
    ];
  };
}
