{ config, pkgs, ... }:
{
  # declaration of awesome wm is in hosts/<name>/default.nix
  home.file.".wallpaper.png".source = ../../../../images/wallpaper.png;
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
}
