{
  description = "My nix setup";
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";

    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    purge = {
      url = "github:therealr5/purge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trucksimulatorbot = {
      url = "github:therealr5/TruckSimulatorBot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pfersel = {
      url = "github:therealr5/pfersel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-index-database
    , sops-nix
    , agenix
    , impermanence
    , nix-colors
    , nixos-hardware
    , lanzaboote
    , purge
    , trucksimulatorbot
    , pfersel
    , ...
    }@attrs: {
      packages.x86_64-linux = {
        iso = self.nixosConfigurations.iso.config.system.build.isoImage;
        jmri = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/jmri { };
        adguardian-term = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/adguardian-term { };
        pww = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/pww { };
        gnome-break-timer = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/gnome-break-timer { };
        hashcash-milter = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/hashcash-milter { };
      };
      hydraJobs = self.packages;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      overlays.default = import ./overlays;
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
            agenix.nixosModules.default
            nix-index-database.nixosModules.nix-index
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
            {
              nixpkgs.overlays = [ self.overlays.default ];
              home-manager.extraSpecialArgs = attrs;
              home-manager.users.rouven = {
                imports = [
                  nix-colors.homeManagerModules.default
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
        nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            nixos-hardware.nixosModules.common-pc-ssd
            nix-index-database.nixosModules.nix-index
            impermanence.nixosModules.impermanence
            ./hosts/nuc
            ./shared
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [ self.overlays.default ];
            }
          ];
        };
        falkenstein-1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            ./hosts/falkenstein-1
            ./shared
            ./shared/sops.nix
            {
              nixpkgs.overlays = [ self.overlays.default ];
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            purge.nixosModules.default
            trucksimulatorbot.nixosModules.default
            pfersel.nixosModules.default
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
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
            ./shared/vim.nix
            ./shared/tmux.nix
          ];
        };
      };
    };
}
