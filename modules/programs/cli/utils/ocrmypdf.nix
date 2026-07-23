{
  config,
  pkgs,
  ...
}:
let
  ocrmypdf = pkgs.stdenv.mkDerivation {
    pname = "ocrmypdf";
    version = "17.8.1";

    nativeBuildInputs = [
      pkgs.uv
      pkgs.python312
    ];

    dontUnpack = true;

    buildPhase = ''
      export HOME=$(mktemp -d)
      uv venv --python ${pkgs.python312}/bin/python3
      source .venv/bin/activate
      uv pip install \
        --extra-index-url https://download.pytorch.org/whl/cu124 \
        ocrmypdf==17.8.1 \
        ocrmypdf-easyocr==0.3.0
      mkdir -p $out/bin
      cp $PWD/.venv/bin/ocrmypdf $out/bin/ocrmypdf
      chmod +x $out/bin/ocrmypdf
      sed -i '1s|#!/nix/store/[^/]*/bin/python3|#!/usr/bin/env python3|' $out/bin/ocrmypdf
    '';

    installPhase = "true";

    outputHashMode = "recursive";
    outputHash = "sha256-HYNrR7kQNvxjM/2tHCYmfxwZV1V9KH13LxfHEj0Tk7M=";
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
