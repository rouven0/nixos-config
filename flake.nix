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

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-colors.url = "github:Misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";

    purge = {
      url = "github:therealr5/purge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trucksimulatorbot = {
      url = "github:therealr5/TruckSimulatorBot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
    , impermanence
    , nix-colors
    , nixos-hardware
    , lanzaboote
    , purge
    , trucksimulatorbot
    , simple-nixos-mailserver
    , ...
    }@attrs: {
      packages.x86_64-linux = {
        iso = self.nixosConfigurations.iso.config.system.build.isoImage;
        jmri = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/jmri { };
        adguardian-term = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/adguardian-term { };
        pww = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/pww { };
      };
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
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
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
            impermanence.nixosModules.impermanence
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
            trucksimulatorbot.nixosModules.default
            simple-nixos-mailserver.nixosModules.default
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
            ./shared/vim.nix
            ./shared/tmux.nix
          ];
        };
      };
    };
}
