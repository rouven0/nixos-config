{ ... }:
{
  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
  services.pcscd.enable = true;
}
