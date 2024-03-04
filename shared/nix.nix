{ config, lib, nixpkgs, ... }:
{
  nix = {
    # expose all flake inputs through nix Path and registry
    registry = {
      nixpkgs.flake = nixpkgs;
    };
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      substituters = [
        "https://cache.rfive.de"
        # temp disabled until logging error is resolved
        # "https://cache.ifsr.de"
      ];
      trusted-public-keys = [
        "cache.rfive.de:of5d+o6mfGXQSR3lk6ApfDBr4ampAUaNHux1O/XY3Tw="
        # "cache.ifsr.de:y55KBAMF4YkjIzXwYOKVk9fcQS+CZ9RM1zAAMYQJtsg="
      ];
    };
  };
}
