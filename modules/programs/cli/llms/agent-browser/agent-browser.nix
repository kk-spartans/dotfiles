{ config, pkgs, hostname, ... }:

let
  isMacPro = hostname == "mac-pro";

  # mac-pro only: drives the persistent real-Chrome service over the tailnet
  # (https://browsers.services.spartans routes /json/* + /devtools/* to Chrome
  # running on mac-pro under Xvfb; nothing is published on any host port).
  # Log into Google by hand once in the noVNC UI; the agent inherits the
  # persisted session. No license keys. Override with BROWSERS_BASE.
  #
  # agent-browser is a static binary with its own CA bundle, so it cannot be
  # taught the gateway's private CA and would refuse the wss:// endpoint.
  # Fetch /json/version over https (curl does trust it) and then dial the
  # plaintext loopback port the cdp-proxy also publishes — same nginx, same
  # Chrome, same session. Override with BROWSERS_WS=... to point elsewhere.
  agent-browser-tailnet = pkgs.writeShellApplication {
    name = "agent-browser";
    runtimeInputs = [
      pkgs.agent-browser
      pkgs.curl
      pkgs.python3
    ];

    text = ''
      set -euo pipefail

      BASE="''${BROWSERS_BASE:-https://browsers.services.spartans}"

      WS="$(${pkgs.curl}/bin/curl -sf -m 15 "$BASE/json/version" | ${pkgs.python3}/bin/python3 -c '
import json, os, sys, urllib.parse
url = json.load(sys.stdin)["webSocketDebuggerUrl"]
override = os.environ.get("BROWSERS_WS")
if override:
    print(override + urllib.parse.urlparse(url).path)
else:
    p = urllib.parse.urlparse(url)
    print("ws://127.0.0.1:9223" + p.path)
')"
      if [ -z "$WS" ]; then
        echo "agent-browser: no Chrome reachable via $BASE." >&2
        echo "On mac-pro: cd ~/things/docker/browsers && docker compose up -d" >&2
        echo "Watch it at https://browsers.services.spartans/vnc.html" >&2
        exit 1
      fi

      exec ${pkgs.agent-browser}/bin/agent-browser --cdp "$WS" "$@"
    '';
  };

  agent-browser = if isMacPro then agent-browser-tailnet else pkgs.agent-browser;
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
