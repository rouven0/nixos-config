{ config, pkgs, ... }:
{
  # declaration of awesome wm is in hosts/<name>/default.nix
  home.file.".wallpaper.jpg".source = ../../../../images/wallpaper.jpg;
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
}
