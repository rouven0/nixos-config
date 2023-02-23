{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    hyprland.url = github:hyprwm/Hyprland;
    sops-nix.url = github:Mic92/sops-nix;
    nix-colors.url = github:Misterio77/nix-colors;
    hyprpaper.url = github:hyprwm/hyprpaper;
    nixos-hardware.url = github:nixos/nixos-hardware;
    nixvim.url = github:pta2002/nixvim;

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprpaper.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprpaper, sops-nix, nix-colors, nixos-hardware, nixvim }@attrs: {
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
                nix-colors.homeManagerModule
                hyprland.homeManagerModules.default
                nixvim.homeManagerModules.nixvim
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
