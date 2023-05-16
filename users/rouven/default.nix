{ config, pkgs, lib, ... }:
{
  imports = [ ./fixes.nix ];
  nixpkgs.config.allowUnfree = true;
  users.users.rouven = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" ];
  };
  system.activationScripts.report-home-manager-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/per-user/rouven/home-manager-*-link | tail -2)
  '';
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
