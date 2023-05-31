{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/adguard
      ./modules/networks
      ./modules/backup
      ./modules/hydra
      ./modules/nextcloud
      ./modules/vaultwarden
      ./modules/nginx
      ./modules/nix-serve
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };
  services.btrfs.autoScrub.enable = true;
  nix.settings = {
    cores = 3;
    auto-optimise-store = true;
  };
  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/nixos"
      "/etc/ssh"
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
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop-vim
    helix
    lsof
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

  # firmware updates
  services.fwupd.enable = true;
  users.users.root.initialHashedPassword = "$y$j9T$hYM7FT2hn3O7OWBn9uz8e0$XquxONcPSke6YjdRGwOzGxC0/92hgP7PIB0y0K.Qdr/";
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/ssh/rouven-thinkpad
    ../../keys/ssh/rouven-pixel
    # ../../keys/ssh/rouven-smartcard
  ];

  system.stateVersion = "22.11";

}
