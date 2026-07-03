{
  config,
  pkgs,
  inputs,
  minimal,
  ...
}:
{
  imports = [
    ./opencode.nix
    ./skills.nix
    ./agent-browser.nix
  ];

  home.packages =
    with pkgs;
    [
      pi-coding-agent
      claude-code
      codex
    ]
    ++ (
      if minimal then
        [ ]
      else
        [
          # llama-cpp
          (inputs.diffusion-llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda.override {
            cudaPackages = pkgs.cudaPackages // {
              cuda_cccl = pkgs.cudaPackages.cccl;
            };
          })
          # inputs.ik_llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
          # ollama
          # vllm
        ]
    );
}
