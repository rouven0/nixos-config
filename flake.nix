{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = github:hyprwm/Hyprland;
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = github:Misterio77/nix-colors;
  };

  outputs = { self, nixpkgs, home-manager, hyprland, sops-nix, nix-colors }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/thinkpad
          ./users/rouven
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.users.rouven = {
              imports = [
                nix-colors.homeManagerModule
                hyprland.homeManagerModules.default
              ];
              config.colorScheme = nix-colors.colorSchemes.dracula;
            };
          }
        ];
      };
    };
  };
}
