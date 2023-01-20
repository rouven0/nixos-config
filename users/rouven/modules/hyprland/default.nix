{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  # TODO integrate this to nix-colors
  xdg.configFile."wofi".source = ./wofi-config;
  home.packages = with pkgs; [
    wofi
    #noto-fonts-emoji
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
}
