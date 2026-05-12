{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.fd = {
    enable = true;
    hidden = true;
    extraOptions = [ "--no-ignore" ];
  };
}
