{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.vscode.profiles.default.extensions =
    with pkgs.vscode-extensions;
    [
      ms-vscode.cpptools
      usernamehw.errorlens
      tamasfe.even-better-toml
      mhutchie.git-graph
      jnoortheen.nix-ide
      bmalehorn.vscode-fish
      yzhang.markdown-all-in-one
      shd101wyy.markdown-preview-enhanced
      ms-vscode-remote.remote-ssh
      ms-vscode.remote-explorer
      rust-lang.rust-analyzer
      bradlc.vscode-tailwindcss
      vscodevim.vim
      redhat.vscode-xml
      redhat.vscode-yaml
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-filesize";
        publisher = "mkxml";
        version = "3.2.2";
        sha256 = "sha256-RVhgCt/zY155oeL7EbVBokNFFBB9xvGL3j3zySdjGRg=";
      }
      {
        name = "ty";
        publisher = "astral-sh";
        version = "2026.44.0";
        sha256 = "sha256-0D/ZGHSDxtUfuQEL9C8ID/UZo7OPoT948tgKFBE3Hyw=";
      }
      {
        name = "gitlantis";
        publisher = "brian-njogu";
        version = "0.0.7";
        sha256 = "sha256-aEzCcUpqRrpmutQMtsLD81DDAMxJoMbTp8ldL80HOA8=";
      }
      {
        name = "vscode-typescript-next";
        publisher = "ms-vscode";
        version = "6.0.20260416";
        sha256 = "sha256-/lvP3a2IJ4PhwThvx0J8wDcch2te2Ezs8v0Lh9A5bpg=";
      }
      {
        name = "opencode";
        publisher = "sst-dev";
        version = "0.0.13";
        sha256 = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
      }
      {
        name = "oxc-vscode";
        publisher = "oxc";
        version = "1.54.0";
        sha256 = "sha256-l/Gpu3cTDDh509keN4WS86TDd/C2LHqdrk8sXUyoh/c=";
      }
      {
        name = "pretty-ts-errors";
        publisher = "yoavbls";
        version = "0.8.7";
        sha256 = "sha256-ofh19dkK+b1+eqr5g4opoLg3a06C/qqC0HVws28jI/A=";
      }
      {
        name = "symbols";
        publisher = "miguelsolorio";
        version = "0.0.25";
        sha256 = "sha256-nhymeLPfgGKyg3krHqRYs2iWNINF6IFBtTAp5HcwMs8=";
      }
      {
        name = "vesper-black";
        publisher = "jach";
        version = "0.1.6";
        sha256 = "sha256-JhuBXauPMvILzs6Dzvm9etrn+U2g9tdsIlFq7nOVPAE=";
      }
    ];
}
