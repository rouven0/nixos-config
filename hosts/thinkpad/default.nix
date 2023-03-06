{ config, pkgs, lib, inputs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [
      ./hardware-configuration.nix
      ./modules/networks
      ./modules/greetd
      ./modules/snapper
      ../../shared/vim.nix
      ../../shared/sops.nix
      ../../shared/gpg.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.editor = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
    font = "Lat2-Terminus16";
    colors =
      let colors = config.home-manager.users.rouven.colorScheme.colors;
      in
      [
        colors.base00
        colors.base08
        colors.base0A
        colors.base0B
        colors.base0D
        colors.base0E
        colors.base0C
        colors.base05

        colors.base03
        colors.base08
        colors.base0A
        colors.base0B
        colors.base0D
        colors.base0E
        colors.base0C
        colors.base07
      ];
  };

  fonts.fonts = with pkgs; [
    nerdfonts
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
  xdg.portal = {
    enable = true;
    extraPortals = [
      inputs.xdph.packages.x86_64-linux.default
    ];
  };

  programs.dconf.enable = true;

  # control display backlight
  programs.light.enable = true;

  services = {
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    printing.enable = true;
    fprintd.enable = true; # log in using fingerprint
    openssh.enable = true; # enabled ssh to have the host keys
    btrfs.autoScrub.enable = true; # periodically check filesystem and repair it
    fwupd.enable = true; # firmware updates
  };

  programs.steam.enable = true; # putting steam in here cause in home manager it doesn't work

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

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
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    gcc
    git
    htop-vim
    dig
    traceroute
    killall
    python3
    zip
    unzip
  ];

  system.stateVersion = "22.11";
}
