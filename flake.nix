{
  description = "My nix setup";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:Misterio77/nix-colors";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs = {
        xdph.follows = "xdph";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    purge = {
      url = "github:therealr5/purge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trucksimulatorbot-images = {
      url = "github:therealr5/trucksimulatorbot-images";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , home-manager
    , nix-index-database
    , impermanence
    , hyprland
    , sops-nix
    , nix-colors
    , nixos-hardware
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
            nix-index-database.nixosModules.nix-index
            {
              home-manager.extraSpecialArgs = attrs;
              home-manager.users.rouven = {
                imports = [
                  nix-colors.homeManagerModules.default
                  hyprland.homeManagerModules.default
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
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            ./hosts/vm
            ./shared
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
