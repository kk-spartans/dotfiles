{ config, pkgs, ... }:
let
  ocrmypdf = pkgs.writeShellApplication {
    name = "ocrmypdf";
    runtimeInputs = [ pkgs.uv ];
    text = ''
      export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
      exec uvx --extra-index-url https://download.pytorch.org/whl/cu121 --with git+https://github.com/ocrmypdf/OCRmyPDF-EasyOCR.git --python 3.12 ocrmypdf "$@"
    '';
  };
in
{
  home.packages = [
    ocrmypdf
    pkgs.tesseract
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
