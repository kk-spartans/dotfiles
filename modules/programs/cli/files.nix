{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    rclone
    rsync
    tree
    diskus
    zip
    unzip
    copyparty-full-buggy
    age
    ncdu
  ];

  programs.fd = {
    enable = true;
    hidden = true;
    extraOptions = [ "--no-ignore" ];
  };
}
