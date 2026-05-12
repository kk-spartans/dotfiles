{ pkgs, ... }:
let
  anthropic-skills = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "f458cee31a7577a47ba0c9a101976fa599385174";
    hash = "sha256-jKNYFom6R+Qw7LQ8vFPBe51JpqIP0tTSY8LM4aPlnT4=";
  };

  find-skills = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "c99a72b371b5b4da865f5afa87c5a686f3a46766";
    hash = "sha256-RYwgUf173N4lGalTta4HkBR7sdZwuzRoAY6M8JsT+RY=";
  };

  uv-package-manager = pkgs.fetchFromGitHub {
    owner = "wshobson";
    repo = "agents";
    rev = "9f9ba3237022cd88d8660060fc58e0492002f978";
    hash = "sha256-VIl3qp6wWCfZm+407cyr8/y4B6PelurQ4wvDEw4vfKo=";
  };

  convex = pkgs.fetchFromGitHub {
    owner = "waynesutton";
    repo = "convexskills";
    rev = "8ef49c96675f760dd5569c0588c1abb04cd989dd";
    hash = "sha256-6sjE4qVQy7MZxwy6x6q/SMvrG1LdCsr00rvEH2RLxU4=";
  };

  frontend-slides = pkgs.fetchFromGitHub {
    owner = "zarazhangrui";
    repo = "frontend-slides";
    rev = "8dca834fc61abc9dd633cbe6a74ed7be3d82a608";
    hash = "sha256-PFxTnFWLsK1FycBw6ZD4OW5y6zDx0KMW6l0sHfQ5DJk=";
  };

  opentui = pkgs.fetchFromGitHub {
    owner = "msmps";
    repo = "opentui-skill";
    rev = "61e20f97fbde02ccf115dc49efdeab59cbf60bee";
    hash = "sha256-Qm3pfA7WxYYK5drJZH3h0bgBOkePXPMMubfVNpjAbwg=";
  };

  electron = pkgs.fetchFromGitHub {
    owner = "teachingai";
    repo = "full-stack-skills";
    rev = "aed23d528f0f5517f7ac2e5303baa7ab33c4b1d6";
    hash = "sha256-hkgTYfonSDUUY35YKz7zsv6cETZHhGnVo2SQT4HateU=";
  };
in
{
  programs.agent-skills = {
    enable = true;

    sources = {
      anthropic-skills = {
        path = anthropic-skills;
        subdir = "skills";
      };

      find-skills = {
        path = find-skills;
        subdir = "skills";
      };

      uv-package-manager = {
        path = uv-package-manager;
        subdir = "plugins/python-development/skills";
      };

      convex = {
        path = convex;
        subdir = "skills";
      };

      frontend-slides = {
        path = frontend-slides;
        subdir = ".";
        filter.maxDepth = 1;
      };

      opentui = {
        path = opentui;
        subdir = "skill/opentui";
      };

      electron = {
        path = electron;
        subdir = "skills/electron-skills";
      };
    };

    skills.enable = [
      "frontend-design"
      "find-skills"
      "uv-package-manager"
      "convex"
      "frontend-slides"
      "opentui"
      "electron"
    ];

    targets.agents.enable = true;
  };
}
