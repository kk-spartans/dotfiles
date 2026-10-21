{
  config,
  pkgs,
  ...
}:
{
  # ocrmypdf from nix-packages wraps ghostscript, tesseract, qpdf, unpaper,
  # pngquant, jbig2enc and jbig2dec into PATH, so no extra tools here.
  home.packages = with pkgs; [ ocrmypdf ];

  programs.fish.functions.ocrmypdf = ''
    command ocrmypdf --language eng --output-type pdf --verbose 1 --rotate-pages --deskew --clean --force-ocr --pdf-renderer auto --optimize 1 $argv
  '';
}
