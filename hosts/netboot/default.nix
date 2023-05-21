{ config, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/netboot/netboot-minimal.nix"

  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };
  programs.git.enable = true;

  # in case we need to rescue a zfs machine
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "23.05";


}
