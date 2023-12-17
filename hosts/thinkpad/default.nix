{ config, pkgs, ... }:
{

  imports =
    [
      ./hardware-configuration.nix
      ./modules/backup
      ./modules/graphics
      ./modules/greetd
      ./modules/networks
      ./modules/printing
      ./modules/security
      ./modules/sound
      ./modules/virtualisation
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelModules = [ "v4l2loopback" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
    tmp.useTmpfs = true;
  };
  # systemd.package = pkgs.systemd.override { withHomed = false; withUkify = true; };

  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/nixos" # bind mounted from /nix/persist/system/etc/nixos to /etc/nixos
      "/etc/ssh"
      "/etc/secureboot"
      "/root/.ssh"
      "/root/.borgmatic"
      "/root/.local/share/zsh"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "dvorak";


  services = {
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    fwupd.enable = true; # firmware updates
    zfs.autoScrub.enable = true;
  };
  hardware.bluetooth.enable = true;

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey = ignore
    '';
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  documentation.dev.enable = true;
  system.stateVersion = "22.11";
}
