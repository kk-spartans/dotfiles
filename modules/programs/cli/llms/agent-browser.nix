{
  config,
  pkgs,
  inputs,
  ...
}:
let
  agent-browser = pkgs.writeShellApplication {
    name = "agent-browser";
    runtimeInputs = with pkgs; [
      pnpm
      nodejs
    ];
    text = ''
      # docker run -d --name cloak -p 127.0.0.1:9222:9222 cloakhq/cloakbrowser cloakserve
      exec pnpm dlx agent-browser --cdp 9222 "$@"
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
