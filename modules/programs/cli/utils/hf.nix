{
  config,
  pkgs,
  inputs,
  ...
}:
let
  hf = pkgs.writeShellApplication {
    name = "hf";
    runtimeInputs = [ pkgs.uv ];
    text = ''
      export HF_XET_HIGH_PERFORMANCE=1
      export HF_XET_NUM_CONCURRENT_RANGE_GETS=32
      # export HF_HUB_ENABLE_HF_TRANSFER=1
      export HF_HUB_DISABLE_XET=1 # you would be surprised how much faster this is
      exec uvx --with hf_transfer --with hf-xet hf "$@"
    '';
  };
in
{
  home.packages = [ hf ];
}
