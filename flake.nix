{
  description = "My nix setup";
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-colors.url = "github:Misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland/";

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
    { self
    , nixpkgs
    , home-manager
    , nix-index-database
    , hyprland
    , sops-nix
    , nix-colors
    , nixos-hardware
    , purge
    , trucksimulatorbot-images
    , ...
    }@attrs: {
      packages.x86_64-linux.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
      packages.x86_64-linux.jmri = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/jmri { };
      hydraJobs = self.packages;
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
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
          ];
        };
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.inputs = attrs;
          modules = [
            ./hosts/iso
            ./shared/caches.nix
            ./shared/vim.nix
          ];
        };
      };
    };
}
