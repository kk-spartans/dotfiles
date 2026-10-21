{
  config,
  pkgs,
  inputs,
  minimal,
  gpu,
  ...
}:
{
  imports = [
    ./opencode.nix
    ./skills.nix

    inputs.nix-packages.homeManagerModules.agent-browser
    inputs.nix-packages.homeManagerModules.completions
  ];

  programs.agent-browser.enable = true;
  programs.cli-completions.enable = true;

  home.packages =
    with pkgs;
    [
      pi-coding-agent
      claude-code
      codex
    ]
    ++ (
      if minimal || gpu != "nvidia" then
        [
          pkgs.llama-cpp
        ]
      else
        [
          pkgs.llama-cpp
          # (inputs.diffusion-llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda.override {
          #   cudaPackages = pkgs.cudaPackages // {
          #     cuda_cccl = pkgs.cudaPackages.cccl;
          #  };
          # })
          # inputs.ik_llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
          # ollama
          # vllm
        ]
    );
}
