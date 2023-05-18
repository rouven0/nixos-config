{ pkgs, modulesPath, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${modulesPath}/virtualisation/qemu-vm.nix"
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };
  networking.hostName = "vm";
  # environment.persistence."/nix/persistent/system" = {
  #   directories = [ "/etc/nixos" ];
  #   files = [ "/etc/machine-id" ];
  # };


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

  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$Y2N3qdQL/irp4wM5$dxUv1vyACcf/lE69tHiobTgNbW8v2sbrlvCsAbv8YXmRV4fxS45p0uly.1sv2l0uRN1Y8dxnNFQASRN5qNJk71";
    openssh.authorizedKeys.keyFiles = [
      ../../keys/ssh/rouven-thinkpad
    ];
  };
  system.stateVersion = "22.11";

}
