{ config, pkgs, ... }:
{
  # theme hardcoded to dracula, too lazy to make all this base16
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = (pkgs.callPackage ../../../../pkgs/dracula-icon-theme { });
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };
}
