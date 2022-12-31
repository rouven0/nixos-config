{ config, pkgs, ... }:
{
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = ../../../../images/wallpaper-blurred.png;
    greeters.slick = {
      enable = true;
      extraConfig = ''
        logo = ${../../../../images/nixos-logo.png}
        show-a11y=false
        show-hostname=false
      '';
    };
  };
}
