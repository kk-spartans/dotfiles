{
  config,
  pkgs,
  inputs,
  ...
}:
let
  agent-browser-bin = pkgs.rustPlatform.buildRustPackage rec {
    pname = "agent-browser";
    version = "0.32.3";

    src = pkgs.fetchurl {
      url = "https://github.com/vercel-labs/agent-browser/archive/v${version}.tar.gz";
      hash = "sha256-u6fi6GwQ0nCH7GbO4TDwKyOWb8NkT+vMMB8UtDIpM9M=";
    };

    buildAndTestSubdir = "cli";
    cargoRoot = "cli";

    doCheck = false;

    cargoHash = "sha256-t+Lk72YPMH5SEl0HsS57WOFnvX6ryUA5Ec10jvOFeCk=";
  };

  agent-browser = pkgs.writeShellApplication {
    name = "agent-browser";
    runtimeInputs = [
      agent-browser-bin
      pkgs.docker
    ];

    text = ''
      set -euo pipefail

      CONTAINER_NAME="cloak"
      IMAGE="cloakhq/cloakbrowser"
      CDP_PORT="9222"

      if ! docker inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
        docker run -d \
          --name "$CONTAINER_NAME" \
          -p 127.0.0.1:''${CDP_PORT}:9222 \
          "$IMAGE" cloakserve >/dev/null
      elif [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME")" != "true" ]; then
        docker start "$CONTAINER_NAME" >/dev/null
      fi

      exec ${agent-browser-bin}/bin/agent-browser --cdp "$CDP_PORT" "$@"
    '';
  };
in
{
  home.packages = [ agent-browser ];

  programs.agent-skills = {
    sources.agent-browser = {
      path = pkgs.fetchFromGitHub {
        owner = "vercel-labs";
        repo = "agent-browser";
        rev = "82eadcee41240b1c8477870f846bc8528e77a8a6";
        hash = "sha256-NbIl24zbSqAbKbZcT5mGGgaUmT1FIwnUMMkMx+za0DU=";
      };
      subdir = "skills";
    };

    skills.enable = [ "agent-browser" ];
  };

  home.file.".agent-browser/config.json".text = ''
    {
      "$schema": "https://agent-browser.dev/schema.json",
      "profile": "~/.agent-browser/browser-data",
      "headed": true
    }
  '';
}
