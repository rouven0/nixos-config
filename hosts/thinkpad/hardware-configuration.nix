{ pkgs, config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  environment.systemPackages = with pkgs; [
    nvme-cli
    intel-gpu-tools
    lm_sensors
    pciutils
  ];
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
      systemd.enable = true;
      luks.devices."luksroot" = {
        device = "/dev/disk/by-uuid/6b89181c-71e0-4e84-8523-2456d3e28400";
        allowDiscards = true;
      };
      luks.devices."luksswap" = {
        device = "/dev/disk/by-uuid/4a5fd2d9-1b37-4895-a24b-835a9cd4063e";
      };

    };
    kernelModules = [ "kvm-intel" ];
    zfs = {
      allowHibernation = true;
      forceImportRoot = false;
    };

  };


  fileSystems."/nix" =
    {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };

  fileSystems."/var/lib" =
    {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/nixos/home";
      fsType = "zfs";
    };
  fileSystems."/" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DF86-7611";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/1dd20f07-877c-4ee5-bef5-5e8c6ebe7927"; }];
  boot.resumeDevice = "/dev/disk/by-uuid/1dd20f07-877c-4ee5-bef5-5e8c6ebe7927";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
