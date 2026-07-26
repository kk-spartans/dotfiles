{
  module =
    { ... }:
    {
      programs.bun.enable = true;
    };

  overlay =
    instructionSets: final: prev:
    let
      needsBaseline = prev.stdenv.hostPlatform.isx86_64 && !builtins.elem "avx2" instructionSets;
    in
    prev.lib.optionalAttrs needsBaseline {
      bun = prev.bun.overrideAttrs (
        finalAttrs: previousAttrs: {
          src = prev.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-x64-baseline.zip";
            hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
          };

          sourceRoot = "bun-linux-x64-baseline";

          passthru = previousAttrs.passthru // {
            baseline = true;
            requiredInstructionSets = instructionSets;
          };
        }
      );
    };
}
