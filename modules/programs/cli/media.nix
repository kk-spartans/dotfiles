{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    yt-dlp
    sox
    ffmpeg
    spotdl
    pandoc
    img2pdf
    ansi2html
  ];
}
