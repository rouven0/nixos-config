{ ... }:
{
  nix.settings = {
    substituters = [
      "https://cache.rfive.de"
    ];
    trusted-public-keys = [
      "cache.rfive.de:2E/yzJduGj4SJqYqDhpXO7aM2m5buMMUHN64EZdml3I="
    ];
  };
}
