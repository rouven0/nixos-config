{ config, ... }:
{
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  xdg.configFile."awesome/wallpaper.png".source = ../../../../images/wallpaper.png;
}
