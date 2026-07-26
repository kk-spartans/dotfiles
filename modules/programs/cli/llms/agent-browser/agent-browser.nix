{
  config,
  pkgs,
  ...
}:
let
  agent-browser = pkgs.writeShellApplication {
    name = "agent-browser";
    runtimeInputs = [
      pkgs.agent-browser-bin
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

      exec ${pkgs.agent-browser-bin}/bin/agent-browser --cdp "$CDP_PORT" "$@"
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
