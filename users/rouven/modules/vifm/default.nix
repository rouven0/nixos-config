{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ vifm ];
  xdg.configFile."vifm/vifmrc".source = ./vifmrc;
  xdg.configFile."vifm/colors/dracula.vifm".source = ./dracula.vifm;
}
