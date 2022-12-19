{ config, pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
