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
  ];

  hardware.printers.ensurePrinters = [ ];
}
