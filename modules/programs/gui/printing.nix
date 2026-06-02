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
    drivers = [ pkgs.gutenprint ];
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
