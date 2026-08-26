{
  description = "nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
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

    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ik_llama-cpp = {
    #   url = "github:ikawrakow/ik_llama.cpp";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # diffusion-llama-cpp = {
    #   url = "github:danielhanchen/llama.cpp/diffusion-visual-updates";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-packages = {
      url = "github:kk-spartans/nix-packages?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";
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
          instructionSets,
          pc,
          minimal,
          laptop,
          gpu,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              instructionSets
              minimal
              pc
              laptop
              gpu
              ;
          };

          modules = [
            {
              nixpkgs.overlays = [
                inputs.nix-packages.overlays.default
              ]
              ++ nixpkgs.lib.optionals (!builtins.elem "avx2" instructionSets) [
                inputs.nix-packages.overlays.bun-baseline
              ];
            }

            ./modules/programs/cli/cli.nix
            ./modules/user/user.nix
            ./modules/boot.nix

            ./modules/platforms/gpu.nix
            ./modules/platforms/pc.nix
            ./modules/platforms/laptop.nix

            ./hosts/${hostname}/${hostname}.nix

            { networking.hostName = hostname; }

            inputs.home-manager.nixosModules.default
            inputs.nix-flatpak.nixosModules.nix-flatpak

            {
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  instructionSets
                  minimal
                  pc
                  laptop
                  gpu
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
          instructionSets = [ "avx2" ];

          pc = true;
          minimal = false;
          laptop = true;
          gpu = "nvidia";
        };

        # VM test rig for the Omarchy layer (nixos-rebuild build-vm).
        omarchy-dev = mkHost {
          system = "x86_64-linux";
          hostname = "omarchy-dev";
          instructionSets = [ "avx2" ];

          pc = true;
          minimal = false;
          laptop = false;
          gpu = "none";
        };

        raspi = mkHost {
          system = "aarch64-linux";
          hostname = "raspi";
          instructionSets = [ ];

          pc = false;
          minimal = true;
          laptop = false;
          gpu = "none";
        };

        mac-pro = mkHost {
          system = "x86_64-linux";
          hostname = "mac-pro";
          instructionSets = [
            "sse4_2"
            "avx"
          ];

          pc = false;
          minimal = false;
          laptop = false;
          gpu = "amd-si";
        };
      };
    };
}
