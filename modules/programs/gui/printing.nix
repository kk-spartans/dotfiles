{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
      pkgs.brlaser
    ];
    webInterface = true;
  };

  environment.systemPackages = with pkgs; [
    cups
    cups-filters
    system-config-printer
    avahi
  ];

  hardware.printers.ensurePrinters = [ ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
