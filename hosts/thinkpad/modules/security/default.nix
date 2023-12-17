{ pkgs, lib, agenix, ... }:
{
  age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
  security = {
    polkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      abrmd.enable = true;
      tctiEnvironment.enable = true;
    };
    pam = {
      u2f = {
        enable = true;
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
  };
  services = {
    fprintd.enable = true; # log in using fingerprint
  };
  environment.systemPackages = with pkgs; [
    agenix.packages.x86_64-linux.default
    tpm2-tools
    sbctl
  ];
  # enable secure boot using lanzaboote
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
  };
}
