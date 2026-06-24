{ pkgs, lib }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "waywarp";
  version = "0.1.7";

  src = pkgs.fetchFromGitHub {
    owner = "Xuepoo";
    repo = "waywarp";
    rev = "v${version}";
    hash = "sha256-gd/MEALRULazfjQ3pGmrD/DKh1nlzYH4Fu59SF2NSp0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = with pkgs; [
    wayland
    cairo
    pango
    libxkbcommon
  ];

  meta = with lib; {
    description = "High-performance keyboard-driven mouse control for Wayland compositors";
    homepage = "https://github.com/Xuepoo/waywarp";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
