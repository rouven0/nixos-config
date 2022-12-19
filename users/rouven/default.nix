{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  # Define a user account.
  users.users.rouven = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" ];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.rouven = { lib, pkgs, ... }: {
    imports = [ ./modules ];

    config = {
      home.stateVersion = config.system.stateVersion;
    };
  };
}
