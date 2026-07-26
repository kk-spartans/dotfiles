{
  config,
  pkgs,
  inputs,
  ...
}:
let
  ocrmypdf = inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.ocrmypdf;
in
{
  home.packages = [
    ocrmypdf
    pkgs.tesseract
    pkgs.python312
    pkgs.unpaper
    pkgs.ghostscript
    pkgs.pngquant
    pkgs.jbig2enc
    pkgs.jbig2dec
  ];

  programs.fish.functions.ocrmypdf = ''
    command ocrmypdf --language eng --output-type pdf --verbose 1 --rotate-pages --deskew --clean --force-ocr --pdf-renderer auto --optimize 1 $argv
  '';
}
