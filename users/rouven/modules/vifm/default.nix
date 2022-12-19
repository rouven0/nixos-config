{ config, pkgs, ... }:
{
    home.packages = with pkgs; [ vifm ];
    home.file.".config/vifm/vifmrc".source = ./vifmrc;
    home.file.".config/vifm/colors/dracula.vifm".source = ./dracula.vifm;
}
