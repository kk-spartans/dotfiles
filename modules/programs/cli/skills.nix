{ pkgs, ... }:
let
  anthropic-skills = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "da20c92503b2e8ff1cf28ca81a0df4673debdbf7";
    hash = "sha256-BiZvEV7VK1AwhiGg+pNMgTUQmt4exevLWwL0Brx4YyE=";
  };

  remotion-skills = pkgs.fetchFromGitHub {
    owner = "remotion-dev";
    repo = "skills";
    rev = "277510e78245ac0fa275d7cb6520d52e0ac2e212";
    hash = "sha256-XklSJY8xZMExl+BFtbYo+nQ8qLnmwWipkSZh9ykwt1s=";
  };

  find-skills = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "87dc3636c59d38d7336a1d857f1364699bf38038";
    hash = "sha256-nISOazYZ9I786Nn4TKmFXyK6WiTPdULdAG0aeRUVXvA=";
  };

  uv-package-manager = pkgs.fetchFromGitHub {
    owner = "wshobson";
    repo = "agents";
    rev = "767d969a73ce6608d10ac713e52be9ac7f061ab9";
    hash = "sha256-iCG2MUyJ5l9wknWQ/SQuSG/RlA+ddUkcdU/dLGvWVIU=";
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
    rev = "24e420e4acef9850505142c449415ac867e43633";
    hash = "sha256-635wzPcpJtkmtZsSQWlP5IAQGu3dtDac5I/rWUBYQ8w=";
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
    rev = "b7fc6a870dcef766663952eaf757032a464e989a";
    hash = "sha256-AdCnNNM4OGu1v9ZbChlCEJyrSKUqBoanPpkkAQR0HBQ=";
  };

  react-doctor = pkgs.fetchFromGitHub {
    owner = "millionco";
    repo = "react-doctor";
    rev = "4dc48d7bc5dbb5ba46cd63e5bd20082485630f97";
    hash = "sha256-p1fp2+E7elHyZNaB5EQykQ79F7NFegHjI8EvTMfKDu0=";
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

      remotion-skills = {
        path = remotion-skills;
        subdir = "skills";
        filter.nameRegex = "remotion";
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

      react-doctor = {
        path = react-doctor;
        subdir = ".agents/skills/react-doctor";
      };
    };

    skills.enable = [
      "frontend-design"
      "remotion"
      "find-skills"
      "uv-package-manager"
      "convex"
      "frontend-slides"
      "opentui"
      "electron"
      "react-doctor"
    ];

    targets.agents.enable = true;
  };
}
