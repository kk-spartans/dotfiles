{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    llama-cpp
    # vllm
    # inputs.ik_llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
  ];
}
