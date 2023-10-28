{ config, lib, nixpkgs, ... }:
{
  nix = {
    # expose all flake inputs through nix Path and registry
    registry = {
      nixpkgs.flake = nixpkgs;
    };
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    # keep build-time deps around for offline-rebuilding
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };
}
