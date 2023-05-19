{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vifm
    ffmpegthumbnailer
    dumptorrent
    poppler_utils
    fontpreview
  ];
  xdg.configFile."vifm/vifmrc".source = ./vifmrc;
  xdg.configFile."vifm/colors/dracula.vifm".source = ./dracula.vifm;
  xdg.configFile."vifm/scripts/vifm-sixel" = {
    executable = true;
    source = ./vifm-sixel;
  };

}
