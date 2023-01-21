{ config, pkgs, ... }:
{
  imports = [ ./fixes.nix ];
  nixpkgs.config.allowUnfree = true;
  users.users.rouven = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" ];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.rouven = { lib, pkgs, ... }: {
    imports = [ ./modules ];

    config = {
      home.username = "rouven";
      home.homeDirectory = "/home/rouven";
      home.stateVersion = config.system.stateVersion;
    };
  };
}
