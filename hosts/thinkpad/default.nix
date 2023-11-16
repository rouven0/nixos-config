{ config, pkgs, lib, agenix, ... }:
{

  imports =
    [
      ./hardware-configuration.nix
      ./modules/backup
      ./modules/networks
      ./modules/greetd
      ./modules/virtualisation
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.initrd.systemd.additionalUpstreamUnits = [ "systemd-vconsole-setup.service" ];
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
  # impermanence fixes
  # sops.age.sshKeyPaths = lib.mkForce [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
  # sops.gnupg.sshKeyPaths = lib.mkForce [ ];
  age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
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

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
    fira
  ];

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;

  security = {
    polkit.enable = true;
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
    # homed.enable = true;
    blueman.enable = true; # bluetooth
    devmon.enable = true; # automount stuff
    # printing = {
    #   enable = true;
    #   stateless = true;
    #   browsedConf = ''
    #     BrowsePoll tomate.local
    #     BrowsePoll cups.agdsn.network
    #     LocalQueueNamingRemoteCUPS RemoteName
    #   '';
    # };
    avahi = {
      # autodiscover printers
      enable = true;
      nssmdns = true;
    };
    fprintd.enable = true; # log in using fingerprint
    fwupd.enable = true; # firmware updates
    zfs.autoScrub.enable = true;
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

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    abrmd.enable = true;
    tctiEnvironment.enable = true;
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
  ];

  environment.systemPackages = with pkgs; [
    # hardware utilities
    nvme-cli
    intel-gpu-tools
    tpm2-tools

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
    man-pages
    openssl
    cups
    agenix.packages.x86_64-linux.default
    mosh
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "user1";
      }
    ];
  };

  programs.java.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };
  security.wrappers.etherape = {
    source = "${pkgs.etherape}/bin/etherape";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "wireshark"; # too lazy to create a new one
    permissions = "u+rx,g+x";
  };

  documentation.dev.enable = true;


  system.stateVersion = "22.11";
}
