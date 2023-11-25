{ config, pkgs, ... }:
{

  imports =
    [
      ./hardware-configuration.nix
      ./modules/backup
      ./modules/graphics
      ./modules/greetd
      ./modules/networks
      ./modules/security
      ./modules/sound
      ./modules/virtualisation
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    tmp.useTmpfs = true;
  };
  systemd.package = pkgs.systemd.override { withHomed = false; };

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
      nssmdns = true;
    };
    fwupd.enable = true; # firmware updates
    zfs.autoScrub.enable = true;
  };
  hardware.bluetooth.enable = true;

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "user1";
      }
    ];
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
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
