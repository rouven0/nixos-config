{ ... }:
{
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.rfive.de"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.rfive.de:2E/yzJduGj4SJqYqDhpXO7aM2m5buMMUHN64EZdml3I="
    ];
  };
}
