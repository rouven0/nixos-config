{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    awesome-config.url = github:therealr5/awesome-config;
    awesome-config.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = github:Misterio77/nix-colors;
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, awesome-config, nix-colors }: {
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
                awesome-config.nixosModules.awesome
                nix-colors.homeManagerModule
              ];
              config.colorScheme = nix-colors.colorSchemes.dracula;
            };
          }
        ];
      };
    };
  };
}
