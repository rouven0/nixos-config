{ config, modulesPath, ... }:
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
  services.fwupd.enable = true;

  # in case we need to rescue a zfs machine
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;


}
