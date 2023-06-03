{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [
      ./hardware-configuration.nix
      ./modules/networks
      ./modules/greetd
      ./modules/snapper
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 10;
    };
    loader.systemd-boot.editor = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  nix.settings = {
    auto-optimise-store = true;
  };

  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/nixos" # bind mounted from /nix/persist/system/etc/nixos to /etc/nixos
      "/etc/ssh"
      "/etc/secureboot"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
  # impermanence fixes
  sops.age.sshKeyPaths = lib.mkForce [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
  sops.gnupg.sshKeyPaths = lib.mkForce [ ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
    font = "Lat2-Terminus16";
    colors = let colors = config.home-manager.users.rouven.colorScheme.colors; in
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

  security = {
    polkit.enable = true;
    audit.enable = true;
    auditd.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.dconf.enable = true;

  # control display backlight
  programs.light.enable = true;

  services = {
    homed.enable = true;
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    printing = {
      enable = true;
    };
    avahi = {
      # autodiscover printers
      enable = true;
      nssmdns = true;
    };
    fprintd.enable = true; # log in using fingerprint
    # enabled ssh to have the host keys
    openssh = {
      enable = true;
      openFirewall = false;
    };
    btrfs.autoScrub.enable = true; # periodically check filesystem and repair it
    fwupd.enable = true; # firmware updates
  };

  # fun fact: if I disable this, Hyprland breaks due to missing egl dependencies
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

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';
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

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
  ];

  environment.systemPackages = with pkgs; [
    # hardware utilities
    btdu
    nvme-cli
    intel-gpu-tools

    # system essentials
    wget
    htop-vim
    dig
    traceroute
    whois
    inetutils
    lsof
    killall
    zip
    unzip

    virt-viewer # multi monitor for vms
    sbctl
  ];
  programs.java.enable = true;

  system.stateVersion = "22.11";
}
