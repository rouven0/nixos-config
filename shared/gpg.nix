{ pkgs, ... }:
{
  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
  services.pcscd.enable = true;
}
