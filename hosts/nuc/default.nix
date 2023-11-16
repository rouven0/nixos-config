{ config, pkgs, lib, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./modules/adguard
      ./modules/networks
      ./modules/backup
      ./modules/grafana
      ./modules/prometheus
      ./modules/matrix
      ./modules/nextcloud
      ./modules/seafile
      ./modules/uptime-kuma
      ./modules/vaultwarden
      ./modules/nginx
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.useTmpfs = true;
  };
  systemd.package = pkgs.systemd.override { withHomed = false; };
  services.btrfs.autoScrub.enable = true;

  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/ssh"
      "/root/.borgmatic"
      "/root/.local/share/zsh"
      "/root/.config/borg/security"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
  age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop-vim
    helix
    lsof
    btdu
  ];
  programs.git = {
    enable = true;
    config = {
      user.name = "Rouven Seifert";
      user.email = "rouven@rfive.de";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.mosh.enable = true;
  security = {
    audit.enable = true;
    auditd.enable = true;
  };


  # firmware updates
  services.fwupd.enable = true;
  users.users.root.initialHashedPassword = "$y$j9T$hYM7FT2hn3O7OWBn9uz8e0$XquxONcPSke6YjdRGwOzGxC0/92hgP7PIB0y0K.Qdr/";
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/ssh/rouven-thinkpad
    ../../keys/ssh/root-thinkpad
    ../../keys/ssh/rouven-pixel
    ../../keys/ssh/root-falkenstein
  ];

  system.stateVersion = "22.11";

}
