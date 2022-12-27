{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/autorandr
      ../../shared/vim.nix
      ../../shared/input.nix
      ../../shared/sops.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # used for wireguard
    checkReversePath = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
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

  # enable polkit
  security.polkit.enable = true;

  # Baseline of installed packages
  environment.systemPackages = with pkgs; [
    # essentials
    wget
    gcc
    htop
    dig
    traceroute
    killall
    # dev
    jdk
    maven
  ];

  # control display backlight
  programs.light.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    pcscd.enable = true; # yubikey and smartcard handling
    printing.enable = true;
    fprintd.enable = true; # log in using fingerprint
    picom.enable = true; # window transparency
    openssh.enable = true; # enabled ssh to have the host keys
  };

  programs.steam.enable = true; # putting steam in here cause in home manager it doesn't work

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  system.stateVersion = "22.11";
}

