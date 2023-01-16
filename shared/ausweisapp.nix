{ config, ... }:
{
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}
