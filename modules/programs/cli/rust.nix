{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
        "clippy"
        "rustfmt"
      ];
      targets = [
        "x86_64-unknown-linux-gnu"
        "wasm32-unknown-unknown"
      ];
    })

    sccache
    gcc
  ];

  home.file.".cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "sccache"
  '';
}
