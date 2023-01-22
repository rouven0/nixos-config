{ config, pkgs, lib, ... }:
{
  # theme hardcoded to dracula, too lazy to make all this base16
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };
}
