{
  config,
  pkgs,
  inputs,
  ...
}:
let
  cuda = pkgs.cudaPackages;
in
{
  home-manager.users.kk-spartans.home.packages = [ pkgs.blender ];

  # cuda_nvcc needs to be in buildInputs too so the cuda setup hook
  # picks it up for CUDAToolkit_ROOT (it only processes buildInputs,
  # not nativeBuildInputs, when scanning for include-in-cudatoolkit-root)
  nixpkgs.overlays = [
    (final: prev: {
      openimagedenoise = prev.openimagedenoise.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          final.cudaPackages.cuda_nvcc
        ];
      });
    })
  ];
}
