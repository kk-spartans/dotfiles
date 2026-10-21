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
    inputs.nix-packages.homeManagerModules.spogo
    inputs.nix-packages.homeManagerModules.gogcli
    inputs.nix-packages.homeManagerModules.wacli
    inputs.nix-packages.homeManagerModules.t3
    inputs.nix-packages.homeManagerModules.hf
  ];

  programs.agent-browser.enable = true;

  programs.spogo = {
    enable = true;
    enableFishIntegration = "fish";
  };

  programs.gogcli = {
    enable = true;
    enableFishIntegration = "fish";
  };

  programs.wacli = {
    enable = true;
    enableFishIntegration = "fish";
  };

  programs.t3 = {
    enable = true;
    enableFishIntegration = "fish";
  };

  programs.hf = {
    enable = true;
    enableFishIntegration = "fish";
  };

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
