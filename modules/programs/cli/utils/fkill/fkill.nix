{
  pkgs,
  ...
}:

let
  pnpm = pkgs.pnpm_11;

  fkillSrc = pkgs.runCommand "fkill-cli-9.0.0-source" { } ''
    mkdir -p "$out"

    tar -xzf ${
      pkgs.fetchurl {
        url = "https://registry.npmjs.org/fkill-cli/-/fkill-cli-9.0.0.tgz";
        hash = "sha256-6S6FgJer78LBQ4+wrO6uhqT3BZA0wo+0g++qdiukXLI=";
      }
    } \
      --strip-components=1 \
      -C "$out"

    cp ${./lock.yml} "$out/pnpm-lock.yaml"
  '';

  fkill = pkgs.stdenv.mkDerivation (finalAttrs: {
    __structuredAttrs = true;
    pname = "fkill-cli";
    version = "9.0.0";

    src = fkillSrc;

    nativeBuildInputs = [
      pkgs.nodejs
      pnpm
      pkgs.pnpmConfigHook
      pkgs.makeWrapper
    ];

    pnpmInstallFlags = [
      "--prod"
      "--ignore-scripts"
    ];

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        pnpmInstallFlags
        ;

      inherit pnpm;

      fetcherVersion = 4;

      hash = "sha256-XCM9Efv8j6csdFLiXQRLCx8rQNNfkQ9FCSVqG7ArSdA=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      packageDir="$out/lib/node_modules/fkill-cli"

      mkdir -p "$packageDir" "$out/bin"

      cp cli.js package.json "$packageDir/"
      cp -r node_modules "$packageDir/"

      makeWrapper ${pkgs.nodejs}/bin/node "$out/bin/fkill" \
        --add-flags "$packageDir/cli.js"

      runHook postInstall
    '';

    meta = {
      description = "Fabulously kill processes";
      homepage = "https://github.com/sindresorhus/fkill-cli";
      mainProgram = "fkill";
    };
  });
in
{
  home.packages = [ fkill ];
}
