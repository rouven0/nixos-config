{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = github:hyprwm/Hyprland;
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprpaper.url = github:hyprwm/hyprpaper;
    hyprpaper.inputs.nixpkgs.follows = "nixpkgs";
    #xdph.url = github:hyprwm/xdg-desktop-portal-hyprland;
    #xdph.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = github:Misterio77/nix-colors;
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprpaper, sops-nix, nix-colors }@attrs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = attrs;
        modules = [
          ./hosts/thinkpad
          ./users/rouven
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.extraSpecialArgs = attrs;
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
