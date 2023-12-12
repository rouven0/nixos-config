{ pkgs, nix-colors, ... }:
{

  colorScheme = nix-colors.colorSchemes.dracula;

  # theme hardcoded to dracula, too lazy to make all this base16
  systemd.user.sessionVariables.GTK_THEME = "Dracula";
  qt = {
    enable = true;
    platformTheme = "gtk";
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
