{ config, pkgs, ... }:
{
  # declaration of awesome wm is in hosts/<name>/default.nix
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
}
