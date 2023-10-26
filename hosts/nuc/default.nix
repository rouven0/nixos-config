{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./modules/adguard
      ./modules/networks
      ./modules/backup
      # ./modules/hydra
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
  services.btrfs.autoScrub.enable = true;
  nix.settings = {
    auto-optimise-store = true;
  };

  sops.secrets."store/secretkey" = { };
  nix.extraOptions = ''
    secret-key-files = ${config.sops.secrets."store/secretkey".path}
  '';

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
  # impermanence fixes
  sops.age.sshKeyPaths = lib.mkForce [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
  sops.gnupg.sshKeyPaths = lib.mkForce [ ];

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
