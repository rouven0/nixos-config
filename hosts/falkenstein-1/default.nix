{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/networks
      ./modules/nginx
      ./modules/purge
    ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "/dev/sda";
      };
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    #tmpOnTmpfs = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
  };

  programs.command-not-found.enable = false;
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop-vim
    comma
  ];
  programs.git = {
    enable = true;
    config = {
      user.name = "Rouven Seifert";
      user.email = "rouven@rfive.de";
    };
  };
  services.qemuGuest.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keyFiles = [
    #../../keys/ssh/rouven-thinkpad
    ../../keys/ssh/rouven-pixel
    ../../keys/ssh/rouven-smartcard
  ];

  system.stateVersion = "22.11";

}

