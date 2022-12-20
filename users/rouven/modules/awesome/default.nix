{ config, pkgs, ... }:
{
  # declaration of awesome wm is in hosts/<name>/default.nix
  home.file.".config/awesome/rc.lua".source = ./rc.lua;
}
