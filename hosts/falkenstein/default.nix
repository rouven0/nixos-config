{ pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/backup
      ./modules/logging
      ./modules/dns
      ./modules/fail2ban
      ./modules/mail
      ./modules/networks
      ./modules/nginx
      ./modules/pfersel
      ./modules/purge
      ./modules/trucksimulatorbot
    ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "/dev/sda";
      };
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.rouven = {
    description = "Rouven Seifert";
    isNormalUser = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
    htop-vim
    helix
    lsof
    python3
  ];
  programs.git = {
    enable = true;
    config = {
      user.name = "Rouven Seifert";
      user.email = "rouven@rfive.de";
    };
  };
  services.qemuGuest.enable = true;
  systemd.services.qemu-guest-agent.path = [ pkgs.shadow ]; # fix root password reset

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.journald.gateway.enable = true;
  programs.mosh.enable = true;
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/ssh/rouven-thinkpad
    ../../keys/ssh/rouven-pixel
    # ../../keys/ssh/rouven-smartcard
  ];

  system.stateVersion = "22.11";
}
