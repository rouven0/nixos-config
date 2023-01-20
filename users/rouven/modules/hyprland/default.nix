{ config, pkgs, hyprpaper, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${../../../../images/wallpaper.png}
    wallpaper =, ${../../../../images/wallpaper.png}
  '';
  # TODO integrate this to nix-colors
  xdg.configFile."wofi".source = ./wofi-config;
  home.packages = [
    pkgs.wofi
    hyprpaper.packages.x86_64-linux.default
  ];

  programs.waybar = {
    enable = true;
    #settings = {
    #mainBar = {
    #layer = "top";
    #position = "top";
    #};
    #};
  };

  programs.mako = {
    enable = true;
    backgroundColor = "#${config.colorScheme.colors.base00}FF";
  };
}
