{ config, pkgs, lib, ... }:
{

  imports =
    [
      ./hardware-configuration.nix
      ./modules/networks
      ./modules/greetd
      ./modules/virtualisation
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
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];


    loader.systemd-boot.editor = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "ssh://nuc.lan"
      ];
      trusted-public-keys = [
        "nuc.lan:a9UkVw3AizAKCER1CfNGhx8UOMF4t4UGE3GJ9dmHwJc="
      ];
    };
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
    buildMachines = [
      {
        hostName = "nuc.lan";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = 1;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
    ];
  };

  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/nixos" # bind mounted from /nix/persist/system/etc/nixos to /etc/nixos
      "/etc/ssh"
      "/etc/secureboot"
      "/root/.ssh"
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
      pkgs.xdg-desktop-portal-wlr
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

  programs.steam.enable = true; # putting steam in here cause in home manager it doesn't work

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
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
    pciutils
    lm_sensors

    sbctl

    deploy-rs
  ];
  programs.java.enable = true;

  system.stateVersion = "22.11";
}
