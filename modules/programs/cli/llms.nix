{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # llama-cpp
    inputs.diffusion-llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
    ollama
    # vllm
    # inputs.ik_llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
  ];
}
