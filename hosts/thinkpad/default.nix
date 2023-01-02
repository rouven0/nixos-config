{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [
      ./hardware-configuration.nix
      ./modules/autorandr
      ./modules/networks
      ./modules/lightdm
      ../../shared/vim.nix
      ../../shared/input.nix
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
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        vicious
      ];
    };
    libinput.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

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

  environment.systemPackages = with pkgs; [
    # essentials
    wget
    gcc
    git
    htop
    dig
    traceroute
    killall
  ];

  system.stateVersion = "22.11";
}
