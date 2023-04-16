{
  description = "My nix setup";
  inputs = {
    nixpkgs = {
      url = github:nixos/nixpkgs/nixos-unstable;
    };
    flake-utils = {
      url = github:numtide/flake-utils;
    };
    nixos-hardware = {
      url = github:nixos/nixos-hardware;
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-index-database = {
      url = github:Mic92/nix-index-database;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = github:Misterio77/nix-colors;
    };

    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };


    xdph = {
      url = github:hyprwm/xdg-desktop-portal-hyprland;
    };

    hyprland = {
      url = github:hyprwm/Hyprland;
      inputs = {
        # temp disable cache cause of glibc mismatch
        nixpkgs.follows = "nixpkgs";
        xdph.follows = "xdph";
      };
    };

    hyprpaper = {
      url = github:hyprwm/hyprpaper;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = github:pta2002/nixvim;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    purge = {
      url = github:therealr5/purge;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trucksimulatorbot-images = {
      url = github:therealr5/trucksimulatorbot-images;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-index-database
    , hyprland
    , sops-nix
    , nix-colors
    , nixos-hardware
    , nixvim
    , purge
    , trucksimulatorbot-images
    , ...
    }@attrs: {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            ./hosts/thinkpad
            ./shared
            ./users/rouven
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager.extraSpecialArgs = attrs;
              home-manager.users.rouven = {
                imports = [
                  nix-colors.homeManagerModules.default
                  hyprland.homeManagerModules.default
                  nixvim.homeManagerModules.nixvim
                  sops-nix.homeManagerModules.sops
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
        nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            nixos-hardware.nixosModules.intel-nuc-8i7beh
            nix-index-database.nixosModules.nix-index
            ./hosts/nuc
            ./shared
            sops-nix.nixosModules.sops
          ];
        };
        falkenstein-1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            ./hosts/falkenstein-1
            ./shared
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            purge.nixosModules.default
            trucksimulatorbot-images.nixosModules.default
          ];
        };
      };
    };
}
