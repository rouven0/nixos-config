{ config, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
