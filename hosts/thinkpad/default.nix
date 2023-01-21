{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [
      ./hardware-configuration.nix
      ./modules/networks
      ../../shared/vim.nix
      ../../shared/sops.nix
      ../../shared/gpg.nix
      ../../shared/zsh-fix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
    font = "Lat2-Terminus16";
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
  ];

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  xdg.portal.wlr.enable = true;

  programs.dconf.enable = true;

  # control display backlight
  programs.light.enable = true;

  services = {
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    printing.enable = true;
    fprintd.enable = true; # log in using fingerprint
    openssh.enable = true; # enabled ssh to have the host keys
  };

  programs.steam.enable = true; # putting steam in here cause in home manager it doesn't work

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # fix to enable secure boot in vms
  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
      mode = "0644";
      user = "libvirtd";
    };
  };


  environment.systemPackages = with pkgs; [
    wget
    gcc
    git
    htop
    dig
    traceroute
    killall
    python3
  ];

  system.stateVersion = "22.11";
}
