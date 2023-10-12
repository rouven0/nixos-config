{ lib, pkgs, config, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./zsh.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    helix
  ];

  # in case we need to rescue a zfs machine
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.swraid.enable = lib.mkForce false;


}
