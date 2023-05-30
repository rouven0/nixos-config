{ config, pkgs, ... }:
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
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/ssh/rouven-thinkpad
    ../../keys/ssh/rouven-pixel
    # ../../keys/ssh/rouven-smartcard
  ];

  system.stateVersion = "22.11";

}
