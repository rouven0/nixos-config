{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/autorandr
      ../../shared/vim.nix
      ../../shared/input.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
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
    git
    gcc
    htop
    tmux
    dig
    traceroute
    killall
    # dev
    jdk
    maven
  ];

  programs.light.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # List services that you want to enable:
  services = {
    blueman.enable = true;
    devmon.enable = true;
    pcscd.enable = true; # yubikey and smartcard stuff
    printing.enable = true;
    fprintd.enable = true; # log in using fingerprint
    picom.enable = true;
  };

  programs.steam.enable = true; # putting steam in here since home manager weirdly complains about it

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

