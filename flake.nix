{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    home-manager.url = github:nix-community/home-manager;
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/thinkpad/configuration.nix
          ./users/rouven
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
