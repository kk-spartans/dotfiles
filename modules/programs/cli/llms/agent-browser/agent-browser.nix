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
      pkgs.curl
      pkgs.python3
    ];

    # Drives the persistent real-Chrome service over the tailnet only
    # (~/things/docker/browsers on mac-pro: branded google-chrome-stable
    # under Xvfb, profile in ./profile; no ports published on any host —
    # Tailscale Serve at https://browsers.gute-degree.ts.net routes
    # /json/* + /devtools/* to Chrome and everything else to the noVNC UI).
    # Watch the live session at .../vnc.html — same browser the agent drives.
    # Log into Google by hand once in that UI; the agent inherits the
    # persisted session. No license keys. Override with BROWSERS_BASE.
    text = ''
      set -euo pipefail

      BASE="''${BROWSERS_BASE:-https://browsers.gute-degree.ts.net}"
      WS="$(${pkgs.curl}/bin/curl -sf -m 15 "$BASE/json/version" | ${pkgs.python3}/bin/python3 -c 'import json,sys; print(json.load(sys.stdin)["webSocketDebuggerUrl"])')"
      if [ -z "$WS" ]; then
        echo "agent-browser: no Chrome reachable via $BASE." >&2
        echo "On mac-pro: cd ~/things/docker/browsers && docker compose up -d" >&2
        echo "Watch it at https://browsers.gute-degree.ts.net/vnc.html" >&2
        exit 1
      fi

      exec ${pkgs.agent-browser-bin}/bin/agent-browser --cdp "$WS" "$@"
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
