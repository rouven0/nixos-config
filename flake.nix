{
  description = "My nix setup";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    home-manager.url = github:nix-community/home-manager;
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix }: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/thinkpad
          ./users/rouven
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
