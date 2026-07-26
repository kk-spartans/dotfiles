{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ocrmypdf
    tesseract
    python312
    unpaper
    ghostscript
    pngquant
    jbig2enc
    jbig2dec
  ];

  programs.fish.functions.ocrmypdf = ''
    command ocrmypdf --language eng --output-type pdf --verbose 1 --rotate-pages --deskew --clean --force-ocr --pdf-renderer auto --optimize 1 $argv
  '';
}
