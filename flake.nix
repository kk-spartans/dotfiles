{
  description = "nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master"; # master makes me compile mars, but i'm fine with it

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    debatable = {
      url = "github:kk-spartans/debatable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # aw-watcher-lid = {
    #   url = "github:tobixen/aw-watcher-lid";
    #   flake = false;
    # };

    # aw-watcher-netstatus = {
    #   url = "github:sameersismail/aw-watcher-netstatus";
    #   flake = false;
    # };

    # aw-watcher-lastfm = {
    #   url = "github:0xbrayo/aw-watcher-lastfm";
    #   flake = false;
    # };

    # aw-watcher-utilization = {
    #   url = "github:Alwinator/aw-watcher-utilization";
    #   flake = false;
    # };

    # aw-watcher-input = {
    #   url = "github:ActivityWatch/aw-watcher-input";
    #   flake = false;
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helium = {
      url = "gitlab:ntgn/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };

    # if i delete it ill forget when the author updates
    # hyprland-easymotion = {
    #   url = "github:zakk4223/hyprland-easymotion/eeb0ed676a07c18d10a2cabeb968b4cd5a9e9ae5";
    #   inputs.hyprland.follows = "hyprland";
    # };

    snappy-switcher = {
      url = "github:OpalAayan/snappy-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ie-r = {
      url = "github:miaupaw/ie-r";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ik_llama-cpp = {
    #   url = "github:ikawrakow/ik_llama.cpp";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    diffusion-llama-cpp = {
      url = "github:danielhanchen/llama.cpp/diffusion-visual-updates";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hyprland,
      catppuccin,
      vicinae-extensions,
      vicinae,
      helium,
      nixcord,
      spicetify-nix,
      sops-nix,
      rust-overlay,
      # ik_llama-cpp,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      mkHost =
        {
          system,
          hostname,
          pc,
          minimal,
          laptop,
          nvidia,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              minimal
              pc
              laptop
              nvidia
              ;
          };

          modules = [
            ./modules/programs/cli/cli.nix
            ./modules/user/user.nix
            ./modules/boot.nix

            ./options/nvidia.nix
            ./options/pc.nix
            ./options/laptop.nix

            ./hosts/${hostname}/${hostname}.nix

            { networking.hostName = hostname; }

            inputs.home-manager.nixosModules.default

            {
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  minimal
                  pc
                  laptop
                  nvidia
                  ;
              };
            }
          ];
        };
    in
    {
      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.treefmt);

      nixosConfigurations = {
        kk-spartans = mkHost {
          system = "x86_64-linux";
          hostname = "kk-spartans";

          pc = true;
          minimal = false;
          laptop = true;
          nvidia = false;
        };

        raspi = mkHost {
          system = "aarch64-linux";
          hostname = "raspi";

          pc = false;
          minimal = true;
          laptop = false;
          nvidia = false;
        };
      };
    };
}
