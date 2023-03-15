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
        utils.follows = "flake-utils";
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

    hyprland-protocols = {
      url = github:hyprwm/hyprland-protocols;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdph = {
      url = github:hyprwm/xdg-desktop-portal-hyprland;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprland-protocols.follows = "hyprland-protocols";
      };
    };

    hyprland = {
      url = github:hyprwm/Hyprland;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprland-protocols.follows = "hyprland-protocols";
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
    , ...
    }@attrs: {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            ./hosts/thinkpad
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
                config = {
                  colorScheme = nix-colors.colorSchemes.dracula;
                };
              };
            }
          ];
        };
        nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            nixos-hardware.nixosModules.intel-nuc-8i7beh
            ./hosts/nuc
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
