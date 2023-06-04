{ pkgs, nix-colors, ... }:
{

  # home.packages = with pkgs; [ libsForQt5.qtstyleplugin-kvantum ];
  colorScheme = nix-colors.colorSchemes.dracula;

  # theme hardcoded to dracula, too lazy to make all this base16
  home.sessionVariables.GTK_THEME = "Dracula";
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "Dracula";
  qt = {
    enable = true;
    style = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };
}
